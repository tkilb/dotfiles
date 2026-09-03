#!/usr/bin/env python3
"""Merge ai/ai-permissions-seed.json into live/per-machine AI agent configs.

This keeps a single, portable, git-tracked baseline of trusted
directories/tools/domains in sync across machines without symlinking the
live config files themselves -- those files also accumulate ephemeral,
per-repo or per-session approvals (e.g. one-off "don't ask again" grants
for unrelated projects) that shouldn't be shared across machines or
clutter this repo's git history.

Targets updated from the seed:
  - ~/.copilot/permissions-config.json (live, per-machine)
      locations[*].tool_approvals / allowed_directories -- merged per the
      "locations" section of the seed.
  - ~/.copilot/settings.json (live, per-machine)
      allowedUrls -- merged from the seed's "trusted_domains".
  - ai/antigravity-settings.json (this repo, git-tracked)
      permissions.allow -- gets a "read_url(<domain>)" entry added for
      each seed domain not already covered by an existing read_url/deny
      rule. Other entries (command(...), write_file(...), etc.) are left
      untouched.

Merge semantics are additive/idempotent: existing entries are never
removed, only missing ones are added. Safe to re-run any time, including
automatically on every `copilot` launch.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent
SEED_PATH = REPO_ROOT / "ai-permissions-seed.json"
ANTIGRAVITY_SETTINGS_PATH = REPO_ROOT / "antigravity-settings.json"

COPILOT_HOME = Path(os.environ.get("COPILOT_HOME", str(Path.home() / ".copilot")))
PERMISSIONS_PATH = COPILOT_HOME / "permissions-config.json"
COPILOT_SETTINGS_PATH = COPILOT_HOME / "settings.json"


def expand(path: str) -> str:
    return str(Path(path).expanduser())


def approval_key(approval: dict) -> tuple:
    return (
        approval.get("kind"),
        tuple(sorted(approval.get("commandIdentifiers", []))) or None,
        approval.get("serverName"),
        approval.get("toolName"),
    )


def merge_location(live_loc: dict, seed_loc: dict) -> dict:
    live_loc.setdefault("tool_approvals", [])
    live_loc.setdefault("allowed_directories", [])

    existing_keys = {approval_key(a) for a in live_loc["tool_approvals"]}
    for approval in seed_loc.get("tool_approvals", []):
        if approval_key(approval) not in existing_keys:
            live_loc["tool_approvals"].append(approval)
            existing_keys.add(approval_key(approval))

    seen_dirs = set(live_loc["allowed_directories"])
    for directory in seed_loc.get("allowed_directories", []):
        expanded = expand(directory)
        if expanded not in seen_dirs:
            live_loc["allowed_directories"].append(expanded)
            seen_dirs.add(expanded)

    return live_loc


def write_json(path: Path, data: dict, dry_run: bool) -> None:
    rendered = json.dumps(data, indent=2) + "\n"
    if dry_run:
        print(f"--- would write {path} ---")
        print(rendered)
        return
    tmp_path = path.with_suffix(path.suffix + ".tmp")
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp_path.write_text(rendered)
    tmp_path.replace(path)


def sync_permissions_config(seed: dict, dry_run: bool) -> bool:
    live: dict = {}
    if PERMISSIONS_PATH.exists():
        live = json.loads(PERMISSIONS_PATH.read_text())
    live.setdefault("locations", {})

    before = json.dumps(live, sort_keys=True)
    for raw_key, seed_loc in seed.get("locations", {}).items():
        key = expand(raw_key)
        live_loc = live["locations"].setdefault(key, {})
        merge_location(live_loc, seed_loc)
    changed = json.dumps(live, sort_keys=True) != before

    if changed:
        write_json(PERMISSIONS_PATH, live, dry_run)
    return changed


def sync_copilot_settings(seed: dict, dry_run: bool) -> bool:
    domains = seed.get("trusted_domains", [])
    if not domains:
        return False

    live: dict = {}
    if COPILOT_SETTINGS_PATH.exists():
        live = json.loads(COPILOT_SETTINGS_PATH.read_text())
    live.setdefault("allowedUrls", [])

    seen = set(live["allowedUrls"])
    changed = False
    for domain in domains:
        url = domain if domain.startswith("http") else f"https://{domain}"
        if url not in seen:
            live["allowedUrls"].append(url)
            seen.add(url)
            changed = True

    if changed:
        write_json(COPILOT_SETTINGS_PATH, live, dry_run)
    return changed


READ_URL_RE = re.compile(r"^read_url\(([^)]+)\)$")


def sync_antigravity_settings(seed: dict, dry_run: bool) -> bool:
    domains = seed.get("trusted_domains", [])
    if not domains or not ANTIGRAVITY_SETTINGS_PATH.exists():
        return False

    live = json.loads(ANTIGRAVITY_SETTINGS_PATH.read_text())
    permissions = live.setdefault("permissions", {})
    allow = permissions.setdefault("allow", [])
    deny = set(permissions.get("deny", []))
    ask = set(permissions.get("ask", []))

    existing_domains = set()
    for entry in allow:
        m = READ_URL_RE.match(entry)
        if m:
            existing_domains.add(m.group(1))

    changed = False
    for domain in domains:
        rule = f"read_url({domain})"
        if domain in existing_domains or rule in deny or rule in ask:
            continue
        allow.append(rule)
        existing_domains.add(domain)
        changed = True

    if changed:
        write_json(ANTIGRAVITY_SETTINGS_PATH, live, dry_run)
    return changed


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would change without writing any files.",
    )
    args = parser.parse_args()

    if not SEED_PATH.exists():
        print(f"Seed file not found: {SEED_PATH}", file=sys.stderr)
        return 1

    seed = json.loads(SEED_PATH.read_text())

    changed_any = False
    changed_any |= sync_permissions_config(seed, args.dry_run)
    changed_any |= sync_copilot_settings(seed, args.dry_run)
    changed_any |= sync_antigravity_settings(seed, args.dry_run)

    if changed_any:
        verb = "Would update" if args.dry_run else "Updated"
        print(f"{verb} AI permission config(s) from {SEED_PATH}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
