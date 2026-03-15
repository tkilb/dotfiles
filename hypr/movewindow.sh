#!/usr/bin/env bash
# Move window with workspace wrapping at edges
# Usage: movewindow.sh <direction> <workspace>
#   direction: l, r, u, d
#   workspace: m-1, m+1, r-1, r+1, etc.

direction=$1
workspace=$2

# Get current window address
pre=$(hyprctl -j activewindow | jq -r ".address")

# Try to move window
hyprctl dispatch movewindow "$direction"

# Get new window address
post=$(hyprctl -j activewindow | jq -r ".address")

# If window didnt move, move it to the next workspace
if [[ $post = $pre ]]; then
  if [[ $workspace == "r+1" ]]; then
    current_workspace=$(hyprctl activeworkspace -j | jq -r ".id")
    new_workspace=$(( (current_workspace % 6) + 1 ))
    hyprctl dispatch movetoworkspace $new_workspace
  elif [[ $workspace == "r-1" ]]; then
    current_workspace=$(hyprctl activeworkspace -j | jq -r ".id")
    new_workspace=$(( (current_workspace + 4) % 6 + 1 ))
    hyprctl dispatch movetoworkspace $new_workspace
  else
    hyprctl dispatch movetoworkspace "$workspace"
  fi
fi
