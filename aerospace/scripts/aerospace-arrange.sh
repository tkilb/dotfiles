#!/bin/bash
# Move Chrome → workspace 2, Kitty → workspace 3, Gather → workspace 6
# Zoom + Outlook → workspace B, Slack → workspace C

aerospace list-windows --all | awk -F' *\\| *' '
    /Google Chrome/     { print $1, 2 }
    /kitty/             { print $1, 3 }
    /Slack/             { print $1, 4 }
    /Bitwarden/         { print $1, 5 }
    /Gather/            { print $1, 6 }
    /^Zoom/             { print $1, "B" }
    /Microsoft Outlook/ { print $1, "C" }
' | while read -r window_id workspace; do
  aerospace move-node-to-workspace --window-id "$window_id" "$workspace"
done

sketchybar --reload
