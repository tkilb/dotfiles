#!/bin/bash
AEROSPACE="/opt/homebrew/bin/aerospace"

current_window=$($AEROSPACE list-windows --focused --format '%{window-id}' 2>/dev/null)
$AEROSPACE focus left 2>/dev/null
new_window=$($AEROSPACE list-windows --focused --format '%{window-id}' 2>/dev/null)

if [ "$current_window" = "$new_window" ]; then
    # Get current workspace and all available workspaces
    current_workspace=$($AEROSPACE list-workspaces --focused)
    all_workspaces=$($AEROSPACE list-workspaces --all)
    
    # Find previous workspace in the list
    prev_workspace=$(echo "$all_workspaces" | grep -B1 "^${current_workspace}$" | head -n1)
    
    # If we're at the first workspace, wrap to the last
    if [ "$prev_workspace" = "$current_workspace" ] || [ -z "$prev_workspace" ]; then
        prev_workspace=$(echo "$all_workspaces" | tail -n1)
    fi
    
    $AEROSPACE workspace $prev_workspace
fi
