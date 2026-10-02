#!/usr/bin/env bash
set -euo pipefail

find_real_kitty() {
  local self
  self="$(readlink -f "$0" 2>/dev/null || realpath "$0" 2>/dev/null || echo "$0")"

  while IFS= read -r candidate; do
    [[ -z "$candidate" ]] && continue
    local resolved
    resolved="$(readlink -f "$candidate" 2>/dev/null || realpath "$candidate" 2>/dev/null || echo "$candidate")"
    if [[ -x "$candidate" && "$resolved" != "$self" ]]; then
      echo "$candidate"
      return 0
    fi
  done < <(which -a kitty 2>/dev/null || true)

  for fallback in /usr/bin/kitty /usr/sbin/kitty /usr/local/bin/kitty /opt/homebrew/bin/kitty /Applications/kitty.app/Contents/MacOS/kitty; do
    if [[ -x "$fallback" ]]; then
      local resolved
      resolved="$(readlink -f "$fallback" 2>/dev/null || realpath "$fallback" 2>/dev/null || echo "$fallback")"
      if [[ "$resolved" != "$self" ]]; then
        echo "$fallback"
        return 0
      fi
    fi
  done
  return 1
}

REAL_KITTY="$(find_real_kitty || true)"
if [[ -z "$REAL_KITTY" ]]; then
  echo "Error: Could not locate underlying kitty binary" >&2
  exit 1
fi

# If arguments are passed (e.g. `kitty --class btop-tui -e btop`), pass through directly
if [[ $# -gt 0 ]]; then
  exec "$REAL_KITTY" "$@"
fi

# No arguments: check if a main Kitty window already exists in Hyprland
if command -v hyprctl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
  kitty_client="$(hyprctl clients -j 2>/dev/null | jq -c '[.[] | select((.class | ascii_downcase) == "kitty")] | first // empty')"
  if [[ -n "$kitty_client" ]]; then
    target_ws="$(echo "$kitty_client" | jq -r '.workspace.id // empty')"
    target_addr="$(echo "$kitty_client" | jq -r '.address // empty')"

    if [[ -n "$target_ws" ]]; then
      hyprctl dispatch workspace "$target_ws" >/dev/null 2>&1 || true
    fi
    if [[ -n "$target_addr" ]]; then
      hyprctl dispatch focuswindow "address:$target_addr" >/dev/null 2>&1 || true
    else
      hyprctl dispatch focuswindow "class:kitty" >/dev/null 2>&1 || true
    fi
    exit 0
  fi
fi

# No existing Kitty instance found; launch the real binary
exec "$REAL_KITTY"
