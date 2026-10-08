#!/usr/bin/env bash
set -euo pipefail

# Ensure only one instance runs per session
LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/watch-power.lock"
exec 200>"$LOCK_FILE"
flock -n 200 || exit 0

last_state=""

update_refresh_rate() {
    # Check if laptop display eDP-1 is present
    if ! hyprctl monitors -j 2>/dev/null | grep -q '"name": "eDP-1"'; then
        return 0
    fi

    local current_online
    current_online=$(cat /sys/class/power_supply/ACAD/online 2>/dev/null || echo "1")

    # If AC online state hasn't changed, skip
    if [[ "$current_online" == "$last_state" ]]; then
        return 0
    fi
    last_state="$current_online"

    if [[ "$current_online" == "0" ]]; then
        # Running on battery -> 60Hz
        hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "2880x1920@60", position = "1920x0", scale = 1.88 })' >/dev/null 2>&1
    else
        # Running on AC power -> 120Hz
        hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "2880x1920@120", position = "1920x0", scale = 1.88 })' >/dev/null 2>&1
    fi
}

# Run once immediately on start
update_refresh_rate

# Listen strictly for AC adapter plug/unplug events (ignoring BAT1 percentage ticks)
udevadm monitor --subsystem-match=power_supply --udev | while read -r line; do
    if echo "$line" | grep -qE "power_supply/(ACAD|ucsi-source-psy)"; then
        sleep 0.2
        update_refresh_rate
    fi
done
