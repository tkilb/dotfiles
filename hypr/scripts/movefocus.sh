#!/usr/bin/env bash
# Move focus with workspace wrapping at edges
# Usage: movefocus.sh <direction> <workspace>
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

# Get current window address
pre=$(hyprctl -j activewindow | jq -r ".address")

# Try to move focus
hyprctl eval "hl.dispatch(hl.dsp.focus({direction='$lua_dir'}))"

# Get new window address
post=$(hyprctl -j activewindow | jq -r ".address")

# If focus didn't move, switch workspace
if [[ $post = $pre ]]; then
  if [[ $workspace == "r+1" ]]; then
    current_workspace=$(hyprctl activeworkspace -j | jq -r ".id")
    new_workspace=$(( (current_workspace % 6) + 1 ))
    hyprctl eval "hl.dispatch(hl.dsp.focus({workspace=$new_workspace}))"
  elif [[ $workspace == "r-1" ]]; then
    current_workspace=$(hyprctl activeworkspace -j | jq -r ".id")
    new_workspace=$(( (current_workspace + 4) % 6 + 1 ))
    hyprctl eval "hl.dispatch(hl.dsp.focus({workspace=$new_workspace}))"
  else
    hyprctl eval "hl.dispatch(hl.dsp.focus({workspace='$workspace'}))"
  fi
fi
