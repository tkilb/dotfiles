#!/usr/bin/env bash
# Move window with workspace wrapping at edges
# Usage: movewindow.sh <direction> <workspace>
#   direction: l, r, u, d
#   workspace: m-1, m+1, r-1, r+1, etc.

direction=$1
workspace=$2

# Map short direction to full name required by Lua API
case "$direction" in
  l) lua_dir="left"  ;;
  r) lua_dir="right" ;;
  u) lua_dir="up"    ;;
  d) lua_dir="down"  ;;
  *) lua_dir="$direction" ;;
esac

# Get current window position
get_pos() {
  hyprctl -j activewindow | jq -c ".at"
}

pre=$(get_pos)

# Try to move window
hyprctl eval "hl.dispatch(hl.dsp.window.move({direction='$lua_dir'}))"

# Get new window position
post=$(get_pos)

# If window didn't move, move it to the next workspace
if [[ "$post" == "$pre" ]]; then
  if [[ $workspace == "r+1" ]]; then
    current_workspace=$(hyprctl activeworkspace -j | jq -r ".id")
    new_workspace=$(( (current_workspace % 6) + 1 ))
    hyprctl eval "hl.dispatch(hl.dsp.window.move({workspace=$new_workspace}))"
  elif [[ $workspace == "r-1" ]]; then
    current_workspace=$(hyprctl activeworkspace -j | jq -r ".id")
    new_workspace=$(( (current_workspace + 4) % 6 + 1 ))
    hyprctl eval "hl.dispatch(hl.dsp.window.move({workspace=$new_workspace}))"
  else
    hyprctl eval "hl.dispatch(hl.dsp.window.move({workspace='$workspace'}))"
  fi
fi
