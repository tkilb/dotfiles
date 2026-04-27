#!/usr/bin/env python3
"""
kanban-remind.py — scans 0.Kanban.md and fires macOS notifications
for items past the nudge threshold. Called by launchd daily.
Thresholds are read from notes-config.lua via simple line parsing
to avoid a full Lua runtime dependency.
"""
import re
import subprocess
from datetime import date, datetime
from pathlib import Path

KANBAN = Path.home() / "Notes/work/0.Kanban.md"
CONFIG = Path.home() / ".dotfiles/nvim/lua/notes-config.lua"

def read_threshold(key: str, default: int) -> int:
    try:
        text = CONFIG.read_text()
        m = re.search(rf"{key}\s*=\s*(\d+)", text)
        return int(m.group(1)) if m else default
    except Exception:
        return default

def notify(title: str, message: str):
    script = f'display notification "{message}" with title "{title}" sound name "Basso"'
    subprocess.run(["osascript", "-e", script])

def main():
    nudge_days = read_threshold("nudge_days", 2)
    stale_days = read_threshold("stale_days", 7)
    today = date.today()

    nudge_items = []
    stale_items = []

    pattern = re.compile(r"- \[ \] (.+?)\s*\(added: (\d{4}-\d{2}-\d{2})\)")

    for line in KANBAN.read_text().splitlines():
        m = pattern.search(line)
        if not m:
            continue
        name, added_str = m.group(1), m.group(2)
        added = datetime.strptime(added_str, "%Y-%m-%d").date()
        age = (today - added).days
        if age >= stale_days:
            stale_items.append((name, age))
        elif age >= nudge_days:
            nudge_items.append((name, age))

    if stale_items:
        names = ", ".join(f"{n} ({a}d)" for n, a in stale_items[:3])
        suffix = f" +{len(stale_items)-3} more" if len(stale_items) > 3 else ""
        notify("🔴 Stale Kanban Items", f"{names}{suffix}")

    if nudge_items:
        names = ", ".join(f"{n} ({a}d)" for n, a in nudge_items[:3])
        suffix = f" +{len(nudge_items)-3} more" if len(nudge_items) > 3 else ""
        notify("🟡 Kanban Nudge", f"{names}{suffix}")

if __name__ == "__main__":
    main()
