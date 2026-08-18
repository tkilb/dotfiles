#!/bin/bash

STATE_FILE="/tmp/wiremix_prev_ws"

get_prev_ws() {
    if [ -f "$STATE_FILE" ]; then
        cat "$STATE_FILE"
    else
        echo 1
    fi
}

# Check if wiremix-tui window is already running
if hyprctl clients -j | grep -q '"class": "wiremix-tui"'; then
    ACTIVE_WS=$(hyprctl activeworkspace -j | jq -r '.id')
    WIREMIX_WS=$(hyprctl clients -j | jq -r '.[] | select(.class=="wiremix-tui") | .workspace.id')

    if [ "$ACTIVE_WS" = "$WIREMIX_WS" ]; then
        # Already on Wiremix's workspace: return to previous workspace
        TARGET_WS=$(get_prev_ws)
        hyprctl dispatch workspace "$TARGET_WS"
    else
        # Save active workspace before focusing Wiremix
        echo "$ACTIVE_WS" > "$STATE_FILE"
        hyprctl dispatch focuswindow "class:^(wiremix-tui)$"
    fi
else
    ACTIVE_WS=$(hyprctl activeworkspace -j | jq -r '.id')
    # Save active workspace before jumping to workspace 10
    if [ "$ACTIVE_WS" != "10" ]; then
        echo "$ACTIVE_WS" > "$STATE_FILE"
    fi

    # Launch kitty on workspace 10
    hyprctl dispatch exec "[workspace 10] kitty --class wiremix-tui -e wiremix"

    # Monitor in background: when wiremix closes and workspace 10 is empty, return to previous workspace
    (
        sleep 1
        while hyprctl clients -j | grep -q '"class": "wiremix-tui"'; do
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
