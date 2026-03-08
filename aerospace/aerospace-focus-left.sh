#!/bin/bash
AEROSPACE="/opt/homebrew/bin/aerospace"

current_window=$($AEROSPACE list-windows --focused --format '%{window-id}' 2>/dev/null)
$AEROSPACE focus left 2>/dev/null
new_window=$($AEROSPACE list-windows --focused --format '%{window-id}' 2>/dev/null)

if [ "$current_window" = "$new_window" ]; then
    $AEROSPACE trigger-binding f14 --mode main
fi
