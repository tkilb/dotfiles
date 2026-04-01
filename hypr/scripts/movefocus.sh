#!/usr/bin/env bash
# Move focus with workspace wrapping at edges
# Usage: movefocus.sh <direction> <workspace>
#   direction: l, r, u, d
#   workspace: m-1, m+1, r-1, r+1, etc.

direction=$1
workspace=$2

# Get current window address
pre=$(hyprctl -j activewindow | jq -r ".address")

# Try to move focus
hyprctl dispatch movefocus "$direction"

# Get new window address
post=$(hyprctl -j activewindow | jq -r ".address")

# If focus didnt move, switch workspace
if [[ $post = $pre ]]; then
  if [[ $workspace == "r+1" ]]; then
    current_workspace=$(hyprctl activeworkspace -j | jq -r ".id")
    new_workspace=$(( (current_workspace % 6) + 1 ))
    hyprctl dispatch workspace $new_workspace
  elif [[ $workspace == "r-1" ]]; then
    current_workspace=$(hyprctl activeworkspace -j | jq -r ".id")
    new_workspace=$(( (current_workspace + 4) % 6 + 1 ))
    hyprctl dispatch workspace $new_workspace
  else
    hyprctl dispatch workspace "$workspace"
  fi
fi
