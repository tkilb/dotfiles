#!/bin/bash

AEROSPACE="/opt/homebrew/bin/aerospace"
ORANGE=0xFFD79921
INACTIVE=0xff494d64
TRANSPARENT=0x00000000

# Get current workspace
current_workspace=$($AEROSPACE list-workspaces --focused --format '%{workspace}' 2>/dev/null)

# Count windows in current workspace
window_count=$($AEROSPACE list-windows --workspace "$current_workspace" --count 2>/dev/null)

# If multiple windows, use orange for focused window, otherwise use transparent/inactive
if [ "$window_count" -gt 1 ]; then
    # Multiple windows - show orange border on focused
    borders active_color=$ORANGE inactive_color=$INACTIVE width=5.0
else
    # Single or no windows - hide border by making it same as inactive
    borders active_color=$INACTIVE inactive_color=$INACTIVE width=5.0
fi
