#!/usr/bin/env bash
set -euo pipefail

# Runs inside a Herdr `type = "popup"` keybinding (see
# custom-herdr-tab-hack.md for the full spec/rationale). Prompts for a name,
# then creates a tab with 3 named panes off the tab's root pane:
#   pane 1 (root): "$name vim"
#   pane 2 (split right of pane 1): "$name ai"
#   pane 3 (split down from pane 1): "$name term"

herdr_bin="${HERDR_BIN_PATH:-herdr}"

if ! command -v "$herdr_bin" >/dev/null 2>&1 && [[ "$herdr_bin" != /* ]]; then
  echo "Error: herdr CLI not found (HERDR_BIN_PATH unset and 'herdr' not on PATH)" >&2
  sleep 2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq not found in PATH" >&2
  sleep 2
  exit 1
fi

read -r -p "Tab name: " name

# Trim leading/trailing whitespace and collapse internal whitespace to single
# spaces, since $name is used directly in tab/pane labels.
name="$(printf '%s' "$name" | tr -s '[:space:]' ' ' | sed -e 's/^ *//' -e 's/ *$//')"

if [[ -z "$name" ]]; then
  echo "No name entered, aborting." >&2
  sleep 1
  exit 1
fi

# 1. Create the tab (uses active workspace by default; --focus to switch to it)
created=$("$herdr_bin" tab create --label "$name" --focus)
tab_id=$(printf '%s\n' "$created" | jq -r '.result.tab.tab_id')
pane1=$(printf '%s\n' "$created" | jq -r '.result.root_pane.pane_id')

if [[ -z "$tab_id" || "$tab_id" == "null" || -z "$pane1" || "$pane1" == "null" ]]; then
  echo "Error: failed to create tab (unexpected response from 'herdr tab create')" >&2
  printf '%s\n' "$created" >&2
  sleep 2
  exit 1
fi

# 2. Rename pane 1
"$herdr_bin" pane rename "$pane1" "$name vim"

# 3. Vertical split (side-by-side) off pane 1 -> pane 2 "ai"
split_ai=$("$herdr_bin" pane split "$pane1" --direction right --ratio 0.6 --no-focus)
pane2=$(printf '%s\n' "$split_ai" | jq -r '.result.pane.pane_id')
"$herdr_bin" pane rename "$pane2" "$name ai"

# 4. Horizontal split (stacked) off pane 1 -> pane 3 "term"
# --ratio 0.8 keeps pane1 (vim) at ~80% height, term at ~20% (more room to
# code, less for the scratch terminal).
split_term=$("$herdr_bin" pane split "$pane1" --direction down --ratio 0.8 --no-focus)
pane3=$(printf '%s\n' "$split_term" | jq -r '.result.pane.pane_id')
"$herdr_bin" pane rename "$pane3" "$name term"

exit 0
