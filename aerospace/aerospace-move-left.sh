#!/bin/bash
AEROSPACE="/opt/homebrew/bin/aerospace"

# Get current window and workspace
current_window=$($AEROSPACE list-windows --focused --format '%{window-id}' 2>/dev/null)
current_workspace=$($AEROSPACE list-workspaces --focused --format '%{workspace}' 2>/dev/null)

# Try to move the window to the left within the current workspace
$AEROSPACE move left 2>/dev/null

# Check if the window actually moved
new_window=$($AEROSPACE list-windows --focused --format '%{window-id}' 2>/dev/null)

# If the window didn't move (no window to the left), move to previous workspace
if [ "$current_window" = "$new_window" ]; then
    # Get the previous workspace
    prev_workspace=$($AEROSPACE list-workspaces --monitor focused --format '%{workspace}' | grep -B1 "^${current_workspace}$" | head -n1)
    
    # If we're at the first workspace, wrap to the last
    if [ "$prev_workspace" = "$current_workspace" ] || [ -z "$prev_workspace" ]; then
        prev_workspace=$($AEROSPACE list-workspaces --monitor focused --format '%{workspace}' | tail -n1)
    fi
    
    # Move window to the previous workspace
    $AEROSPACE move-node-to-workspace $prev_workspace
    
    # Focus the new workspace
    $AEROSPACE workspace $prev_workspace
fi
