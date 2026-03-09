#!/bin/bash
AEROSPACE="/opt/homebrew/bin/aerospace"

current_window=$($AEROSPACE list-windows --focused --format '%{window-id}' 2>/dev/null)
$AEROSPACE focus right 2>/dev/null
new_window=$($AEROSPACE list-windows --focused --format '%{window-id}' 2>/dev/null)

if [ "$current_window" = "$new_window" ]; then
    # Get current workspace and all available workspaces
    current_workspace=$($AEROSPACE list-workspaces --focused)
    all_workspaces=$($AEROSPACE list-workspaces --all)
    
    # Find next workspace in the list
    next_workspace=$(echo "$all_workspaces" | grep -A1 "^${current_workspace}$" | tail -n1)
    
    # If we're at the last workspace, wrap to the first
    if [ "$next_workspace" = "$current_workspace" ] || [ -z "$next_workspace" ]; then
        next_workspace=$(echo "$all_workspaces" | head -n1)
    fi
    
    $AEROSPACE workspace $next_workspace
fi
