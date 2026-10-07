#!/usr/bin/env bash
# Wrapper so Herdr plugins that shell out to `node` (resolved via PATH) can
# find it even when the Herdr server was launched by a GUI terminal (kitty)
# via launchd, which doesn't inherit the login shell's PATH (no
# /usr/local/bin, /opt/homebrew/bin, nvm, etc). See:
#   https://github.com/herdrdev/herdr/discussions (plugin node PATH lookup)
set -euo pipefail

find_real_node() {
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
  done < <(which -a node 2>/dev/null || true)

  for fallback in /opt/homebrew/bin/node /usr/local/bin/node /usr/bin/node; do
    if [[ -x "$fallback" ]]; then
      echo "$fallback"
      return 0
    fi
  done
  return 1
}

REAL_NODE="$(find_real_node || true)"
if [[ -z "$REAL_NODE" ]]; then
  echo "Error: Could not locate a real node binary" >&2
  exit 1
fi

exec "$REAL_NODE" "$@"
