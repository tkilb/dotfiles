#!/bin/bash

CONFIG_FILE="${HOME}/.config/hypr/app-workspaces.json"
if [[ ! -f "$CONFIG_FILE" ]]; then
  CONFIG_FILE="${HOME}/.dotfiles/hypr/app-workspaces.json"
fi

# Save the currently focused window
focused_addr=$(hyprctl activewindow -j | jq -r '.address // empty')

# Move all configured app windows to their designated workspaces
if [[ -f "$CONFIG_FILE" ]]; then
  while read -r app_class ws; do
    [[ -z "$app_class" || -z "$ws" ]] && continue
    for addr in $(hyprctl clients -j | jq -r --arg class "$app_class" '.[] | select((.class | ascii_downcase) == ($class | ascii_downcase)) | .address'); do
      hyprctl eval "hl.dispatch(hl.dsp.window.move({window='address:$addr', workspace=$ws, silent=true}))"
    done
  done < <(jq -r 'to_entries[] | "\(.key) \(.value)"' "$CONFIG_FILE")
fi

# Move all Steam games (steam_app_*) to workspace 1
for addr in $(hyprctl clients -j | jq -r '.[] | select(.class | test("^steam_app_")) | .address'); do
  hyprctl eval "hl.dispatch(hl.dsp.window.move({window='address:$addr', workspace=1, silent=true}))"
done

# Restore focus to the original window
if [[ -n "$focused_addr" && "$focused_addr" != "null" ]]; then
  hyprctl eval "hl.dispatch(hl.dsp.focus({window='address:$focused_addr'}))"
fi

original_class=$(hyprctl activewindow -j | jq -r '.class // empty' | tr '[:upper:]' '[:lower:]')
target_ws=1
if [[ -n "$original_class" && -f "$CONFIG_FILE" ]]; then
  lookup_ws=$(jq -r --arg class "$original_class" 'to_entries[] | select((.key | ascii_downcase) == $class) | .value' "$CONFIG_FILE" | head -n 1)
  if [[ -n "$lookup_ws" && "$lookup_ws" != "null" ]]; then
    target_ws="$lookup_ws"
  fi
fi

hyprctl eval "hl.dispatch(hl.dsp.focus({workspace=$target_ws}))"
