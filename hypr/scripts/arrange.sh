#!/bin/bash

# Config: app_class -> workspace mappings (add/remove lines as needed)
declare -A APP_WS=(
  ["factorio"]=1
  ["BambuStudio"]=1
  ["zen"]=2
  ["kitty"]=3
  ["Discord"]=4
  ["Bitwarden"]=5
  ["Spotify"]=5
  ["steam"]=6
)

# Save the currently focused window
focused_addr=$(hyprctl activewindow -j | jq -r '.address')

# Move all configured app windows to their designated workspaces
for app_class in "${!APP_WS[@]}"; do
  ws="${APP_WS[$app_class]}"
  for addr in $(hyprctl clients -j | jq -r --arg class "$app_class" '.[] | select((.class | ascii_downcase) == ($class | ascii_downcase)) | .address'); do
    hyprctl eval "hl.dispatch(hl.dsp.window.move({window='address:$addr', workspace=$ws, silent=true}))"
  done
done

# Move all Steam games (steam_app_*) to workspace 1
for addr in $(hyprctl clients -j | jq -r '.[] | select(.class | test("^steam_app_")) | .address'); do
  hyprctl eval "hl.dispatch(hl.dsp.window.move({window='address:$addr', workspace=1, silent=true}))"
done

# Restore focus to the original window
if [[ -n "$focused_addr" && "$focused_addr" != "null" ]]; then
  hyprctl eval "hl.dispatch(hl.dsp.focus({window='address:$focused_addr'}))"
fi

# Switch to the workspace of the previously focused window
original_class=$(hyprctl activewindow -j | jq -r '.class' | tr '[:upper:]' '[:lower:]')
target_ws="${APP_WS[$original_class]:-1}"

hyprctl eval "hl.dispatch(hl.dsp.focus({workspace=$target_ws}))"
