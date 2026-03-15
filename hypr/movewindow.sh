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
  hyprctl dispatch movetoworkspace "$workspace"
fi
