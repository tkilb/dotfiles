# Waybar & Hyprland Configuration Guidelines

This document outlines system conventions and architectural patterns for modifying Waybar modules, Hyprland integrations, and TUI launchers on this machine.

---

## 1. TUI Workspace Switching Pattern (Workspace 10 + Auto-Return)

When configuring Waybar modules to open TUI applications (`wiremix`, `btop`, `yazi`, `nmtui`, etc.) in Kitty, follow the **Workspace 10 Switchback Pattern**:

### Pattern Summary:
- Launch the TUI in Kitty with a custom window class (e.g. `kitty --class <tui>-tui -e <tui>`) on **Workspace 10** (outside the user's main persistent 1–6 workspaces).
- Save the active workspace ID to `/tmp/<tui>_prev_ws` before jumping to Workspace 10.
- If the TUI window is already open, clicking the Waybar icon focuses that window. If already on Workspace 10, clicking the icon toggles back to the saved previous workspace.
- Run a background loop in the launcher script: when the TUI process exits and Workspace 10 has 0 windows, automatically return focus to the previous workspace.

### Standard Launcher Script Template (`~/.config/waybar/launch_<app>.sh`):

```bash
#!/bin/bash
# Example: ~/.config/waybar/launch_btop.sh

STATE_FILE="/tmp/btop_prev_ws"

get_prev_ws() {
    if [ -f "$STATE_FILE" ]; then
        cat "$STATE_FILE"
    else
        echo 1
    fi
}

# Check if app window is already running
if hyprctl clients -j | grep -q '"class": "btop-tui"'; then
    ACTIVE_WS=$(hyprctl activeworkspace -j | jq -r '.id')
    APP_WS=$(hyprctl clients -j | jq -r '.[] | select(.class=="btop-tui") | .workspace.id')

    if [ "$ACTIVE_WS" = "$APP_WS" ]; then
        # Already on app workspace: return to previous workspace
        TARGET_WS=$(get_prev_ws)
        hyprctl dispatch workspace "$TARGET_WS"
    else
        # Save current active workspace before focusing app
        echo "$ACTIVE_WS" > "$STATE_FILE"
        hyprctl dispatch focuswindow "class:^(btop-tui)$"
    fi
else
    ACTIVE_WS=$(hyprctl activeworkspace -j | jq -r '.id')
    if [ "$ACTIVE_WS" != "10" ]; then
        echo "$ACTIVE_WS" > "$STATE_FILE"
    fi

    # Launch kitty on workspace 10
    hyprctl dispatch exec "[workspace 10] kitty --class btop-tui -e btop"

    # Monitor in background: when app closes and workspace 10 is empty, return to previous workspace
    (
        sleep 1
        while hyprctl clients -j | grep -q '"class": "btop-tui"'; do
            sleep 0.5
        done

        COUNT=$(hyprctl clients -j | jq '[.[] | select(.workspace.id == 10)] | length')
        if [ "$COUNT" -eq 0 ]; then
            TARGET_WS=$(get_prev_ws)
            hyprctl dispatch workspace "$TARGET_WS"
        fi
    ) &
fi
```

---

## 2. Power Button & Scheduled Shutdown Toggle Pattern

For power/shutdown modules in Waybar (`custom/dummy3` or `custom/power`):

### Behavior:
- **Left Click (Idle)**: Schedules a 5-minute shutdown (`shutdown -P 5`), sends a desktop notification via `notify-send`, and signals Waybar (`pkill -RTMIN+11 waybar`).
- **Left Click (Pending)**: Cancels the scheduled shutdown (`shutdown -c`), sends a cancellation notification, and signals Waybar.
- **Dynamic CSS State**: Returns `{"class": "pending"}` when `/run/systemd/shutdown/scheduled` exists.
- **Styling**: `#custom-<name>.pending { color: @red; }` highlights the icon in red during pending shutdowns.

---

## 3. Key Files & Config Paths

| Purpose | File Path |
| :--- | :--- |
| **Waybar Config** | `file:///home/tylerkilburn/.config/waybar/config.jsonc` |
| **Waybar Styling** | `file:///home/tylerkilburn/.config/waybar/style.css` |
| **Wiremix Launcher** | `file:///home/tylerkilburn/.config/waybar/launch_wiremix.sh` |
| **Btop Launcher** | `file:///home/tylerkilburn/.config/waybar/launch_btop.sh` |
| **Shutdown Script** | `file:///home/tylerkilburn/.config/waybar/shutdown_toggle.sh` |

---

## 4. Useful Terminal Commands

- **Reload Waybar Config**: `pkill -USR2 waybar`
- **Trigger Module Signal 11**: `pkill -RTMIN+11 waybar`
- **Inspect Hyprland Windows**: `hyprctl clients -j`
- **Inspect Active Workspace**: `hyprctl activeworkspace -j`
