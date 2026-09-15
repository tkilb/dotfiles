#!/usr/bin/env python3
"""
Rofi Desktop Application Launcher with Web Search Fallback

Behaviors:
1. When called without arguments, lists all desktop applications from standard
   XDG directories with their icons and exec commands.
2. When an application is selected, launches that application in the background.
3. When custom input is entered (fallback search / URL), opens the query in the
   default browser (Google search or direct URL navigation) and focuses Hyprland workspace 2.
"""

import os
import re
import subprocess
import sys
import urllib.parse
from pathlib import Path

APPLICATION_DIRS = [
    Path(os.path.expanduser("~/.local/share/applications")),
    Path("/usr/local/share/applications"),
    Path("/usr/share/applications"),
    Path("/var/lib/flatpak/exports/share/applications"),
    Path(os.path.expanduser("~/.local/share/flatpak/exports/share/applications")),
]

URL_PATTERN = re.compile(
    r"^(https?://)?"
    r"([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}"
    r"(:[0-9]{1,5})?(/.*)?$"
)
IP_OR_LOCALHOST_PATTERN = re.compile(
    r"^(https?://)?(localhost|127\.0\.0\.1|0\.0\.0\.0)(:[0-9]{1,5})?(/.*)?$"
)


def clean_exec(exec_str: str) -> str:
    """Remove desktop entry field codes (%f, %u, %F, %U, etc.)."""
    cleaned = re.sub(r"%[a-zA-Z]", "", exec_str)
    return cleaned.strip()


def parse_desktop_file(file_path: Path):
    """Parse a .desktop file and return (name, icon, exec_cmd) if valid."""
    try:
        content = file_path.read_text(encoding="utf-8", errors="replace")
    except Exception:
        return None

    in_desktop_entry = False
    name = None
    icon = ""
    exec_cmd = None
    no_display = False
    hidden = False
    entry_type = None

    for line in content.splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if line.startswith("[") and line.endswith("]"):
            in_desktop_entry = line == "[Desktop Entry]"
            continue
        if not in_desktop_entry:
            continue

        if "=" in line:
            key, val = line.split("=", 1)
            key = key.strip()
            val = val.strip()
            if key == "Name" and name is None:
                name = val
            elif key == "Icon" and not icon:
                icon = val
            elif key == "Exec" and exec_cmd is None:
                exec_cmd = val
            elif key == "NoDisplay" and val.lower() == "true":
                no_display = True
            elif key == "Hidden" and val.lower() == "true":
                hidden = True
            elif key == "Type":
                entry_type = val

    if no_display or hidden or entry_type not in (None, "Application"):
        return None

    if name and exec_cmd:
        return name, icon, clean_exec(exec_cmd)
    return None


def list_applications():
    """List all desktop applications formatted for Rofi script mode."""
    apps = {}
    for app_dir in APPLICATION_DIRS:
        if not app_dir.is_dir():
            continue
        for desktop_file in app_dir.glob("*.desktop"):
            if desktop_file.name in apps:
                continue
            parsed = parse_desktop_file(desktop_file)
            if parsed:
                apps[desktop_file.name] = parsed

    # Sort alphabetically by application name
    sorted_apps = sorted(apps.values(), key=lambda item: item[0].lower())

    for name, icon, exec_cmd in sorted_apps:
        # Rofi script mode metadata formatting:
        # <entry_label>\0icon\x1f<icon_name>\x1finfo\x1f<exec_command>
        line = f"{name}\0icon\x1f{icon}\x1finfo\x1f{exec_cmd}"
        print(line)


def focus_hyprland_workspace_2():
    """Switch Hyprland focus to workspace 2 and focus the browser window."""
    try:
        # Focus workspace 2
        subprocess.run(
            ["hyprctl", "dispatch", "workspace", "2"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=False,
        )
        # Attempt to focus zen/browser window if active on workspace 2
        subprocess.run(
            ["hyprctl", "dispatch", "focuswindow", "class:zen"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=False,
        )
    except Exception:
        pass


def launch_browser_search(query: str):
    """Open URL or Google search query in default browser and focus workspace 2."""
    query = query.strip()
    if not query:
        return

    # Check if query is already a URL or IP/localhost address
    if query.startswith(("http://", "https://")):
        url = query
    elif URL_PATTERN.match(query) or IP_OR_LOCALHOST_PATTERN.match(query):
        url = f"https://{query}"
    else:
        encoded_query = urllib.parse.quote_plus(query)
        url = f"https://www.google.com/search?q={encoded_query}"

    browser = os.environ.get("BROWSER", "zen")

    # Launch browser detached
    try:
        subprocess.Popen(
            [browser, url],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True,
        )
    except FileNotFoundError:
        # Fallback to xdg-open if configured browser executable is not found
        subprocess.Popen(
            ["xdg-open", url],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True,
        )

    # Focus Hyprland workspace 2
    focus_hyprland_workspace_2()


def get_app_workspace(selection: str, rofi_info: str):
    """Resolve target workspace from app-workspaces.json if defined."""
    config_paths = [
        Path(os.path.expanduser("~/.config/hypr/app-workspaces.json")),
        Path(os.path.expanduser("~/.dotfiles/hypr/app-workspaces.json")),
    ]
    config_file = next((p for p in config_paths if p.is_file()), None)
    if not config_file:
        return None

    try:
        import json
        with open(config_file, "r", encoding="utf-8") as f:
            mappings = json.load(f)
        sel_lower = selection.lower()
        info_lower = rofi_info.lower()
        for app, ws in mappings.items():
            app_lower = app.lower()
            if app_lower in sel_lower or app_lower in info_lower:
                return int(ws)
    except Exception:
        pass
    return None


def main():
    if len(sys.argv) == 1:
        # Initial invocation by Rofi: output application list
        list_applications()
        return

    # Selection or custom input submitted by user
    selected = sys.argv[1]
    rofi_info = os.environ.get("ROFI_INFO", "").strip()

    if rofi_info:
        # User selected a known desktop application
        subprocess.Popen(
            rofi_info,
            shell=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True,
        )
        ws = get_app_workspace(selected, rofi_info)
        if ws:
            try:
                subprocess.run(
                    ["hyprctl", "dispatch", "workspace", str(ws)],
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL,
                    check=False,
                )
            except Exception:
                pass
    else:
        # User entered custom text (search fallback)
        launch_browser_search(selected)


if __name__ == "__main__":
    main()
