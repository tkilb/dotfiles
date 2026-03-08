#!/bin/bash
AEROSPACE="/opt/homebrew/bin/aerospace"

# Get current workspace
current_workspace=$($AEROSPACE list-workspaces --focused --format '%{workspace}' 2>/dev/null)
current_window=$($AEROSPACE list-windows --focused --format '%{window-id}' 2>/dev/null)

# Try to focus right to see if there's a window there
$AEROSPACE focus right 2>/dev/null
focused_after_right=$($AEROSPACE list-windows --focused --format '%{window-id}' 2>/dev/null)

# Focus back to original window
$AEROSPACE focus --window-id "$current_window" 2>/dev/null

# If focus changed when we went right, there's a window to the right - swap with it
if [ "$current_window" != "$focused_after_right" ]; then
    # There's a window to the right, so move right
    $AEROSPACE move right
else
    # No window to the right, move to next workspace
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
