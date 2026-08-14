#!/bin/bash

STATE_FILE="/tmp/btop_prev_ws"

get_prev_ws() {
    if [ -f "$STATE_FILE" ]; then
        cat "$STATE_FILE"
    else
        echo 1
    fi
}

# Check if btop-tui window is already running
if hyprctl clients -j | grep -q '"class": "btop-tui"'; then
    ACTIVE_WS=$(hyprctl activeworkspace -j | jq -r '.id')
    BTOP_WS=$(hyprctl clients -j | jq -r '.[] | select(.class=="btop-tui") | .workspace.id')

    if [ "$ACTIVE_WS" = "$BTOP_WS" ]; then
        # Already on btop's workspace: return to previous workspace
        TARGET_WS=$(get_prev_ws)
        hyprctl dispatch workspace "$TARGET_WS"
    else
        # Save active workspace before focusing btop
        echo "$ACTIVE_WS" > "$STATE_FILE"
        hyprctl dispatch focuswindow "class:^(btop-tui)$"
    fi
else
    ACTIVE_WS=$(hyprctl activeworkspace -j | jq -r '.id')
    # Save active workspace before jumping to workspace 10
    if [ "$ACTIVE_WS" != "10" ]; then
        echo "$ACTIVE_WS" > "$STATE_FILE"
    fi

    # Launch kitty with btop on workspace 10
    hyprctl dispatch exec "[workspace 10] kitty --class btop-tui -e btop"

    # Monitor in background: when btop closes and workspace 10 is empty, return to previous workspace
    (
        sleep 1
        while hyprctl clients -j | grep -q '"class": "btop-tui"'; do
            sleep 0.5
        done

        # Check if workspace 10 is empty
        COUNT=$(hyprctl clients -j | jq '[.[] | select(.workspace.id == 10)] | length')
        if [ "$COUNT" -eq 0 ]; then
            TARGET_WS=$(get_prev_ws)
            hyprctl dispatch workspace "$TARGET_WS"
        fi
    ) &
fi
