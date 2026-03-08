#!/bin/bash
AEROSPACE="/opt/homebrew/bin/aerospace"

# Get current window and workspace
current_window=$($AEROSPACE list-windows --focused --format '%{window-id}' 2>/dev/null)
current_workspace=$($AEROSPACE list-workspaces --focused --format '%{workspace}' 2>/dev/null)

# Try to move the window to the right within the current workspace
$AEROSPACE move right 2>/dev/null

# Check if the window actually moved
new_window=$($AEROSPACE list-windows --focused --format '%{window-id}' 2>/dev/null)

# If the window didn't move (no window to the right), move to next workspace
if [ "$current_window" = "$new_window" ]; then
    # Get the next workspace
    next_workspace=$($AEROSPACE list-workspaces --monitor focused --format '%{workspace}' | grep -A1 "^${current_workspace}$" | tail -n1)
    
    # If we're at the last workspace, wrap to the first
    if [ "$next_workspace" = "$current_workspace" ] || [ -z "$next_workspace" ]; then
        next_workspace=$($AEROSPACE list-workspaces --monitor focused --format '%{workspace}' | head -n1)
    fi
    
    # Move window to the next workspace
    $AEROSPACE move-node-to-workspace $next_workspace
    
    # Focus the new workspace
    $AEROSPACE workspace $next_workspace
fi
