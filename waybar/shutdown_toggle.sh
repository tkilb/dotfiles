#!/bin/bash

STATE_FILE="/run/systemd/shutdown/scheduled"

is_pending() {
    if [ -f "$STATE_FILE" ] || shutdown --show >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

case "$1" in
    toggle)
        if is_pending; then
            shutdown -c
            notify-send "Shutdown Cancelled" "The scheduled 5-minute shutdown has been cancelled." -i system-shutdown-symbolic -u normal -a "System Power"
        else
            shutdown -P 5 "System shutdown scheduled via Waybar"
            notify-send "Shutdown Scheduled" "System will shut down in 5 minutes.\nClick the power icon again to cancel." -i system-shutdown-symbolic -u critical -a "System Power"
        fi
        pkill -RTMIN+11 waybar
        ;;
    status|*)
        if is_pending; then
            echo '{"text": "", "tooltip": "Shutdown scheduled (Click to cancel)", "class": "pending"}'
        else
            echo '{"text": "", "tooltip": "Click to schedule shutdown (5 min)", "class": "normal"}'
        fi
        ;;
esac
