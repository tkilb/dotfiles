#!/bin/bash
AEROSPACE="/opt/homebrew/bin/aerospace"

# Get current workspace
current_workspace=$($AEROSPACE list-workspaces --focused --format '%{workspace}' 2>/dev/null)
current_window=$($AEROSPACE list-windows --focused --format '%{window-id}' 2>/dev/null)

# Try to focus left to see if there's a window there
$AEROSPACE focus left 2>/dev/null
focused_after_left=$($AEROSPACE list-windows --focused --format '%{window-id}' 2>/dev/null)

# Focus back to original window
$AEROSPACE focus --window-id "$current_window" 2>/dev/null

# If focus changed when we went left, there's a window to the left - swap with it
if [ "$current_window" != "$focused_after_left" ]; then
    # There's a window to the left, so move left
    $AEROSPACE move left
else
    # No window to the left, move to previous workspace
    all_workspaces=$($AEROSPACE list-workspaces --all)
    prev_workspace=$(echo "$all_workspaces" | grep -B1 "^${current_workspace}$" | head -n1)
    
    # If we're at the first workspace, wrap to the last
    if [ "$prev_workspace" = "$current_workspace" ] || [ -z "$prev_workspace" ]; then
        prev_workspace=$(echo "$all_workspaces" | tail -n1)
    fi
    
    # Move window to the previous workspace
    $AEROSPACE move-node-to-workspace $prev_workspace
    
    # Focus the new workspace
    $AEROSPACE workspace $prev_workspace
fi
