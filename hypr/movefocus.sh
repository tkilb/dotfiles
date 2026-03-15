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
  hyprctl dispatch workspace "$workspace"
fi
