#!/usr/bin/env bash
set -euo pipefail

MANIFEST_FILE="${HERDR_PLUGINS_MANIFEST:-$HOME/.dotfiles/herdr/plugins.yaml}"
CONFIG_DIR="${HERDR_CONFIG_DIR:-$HOME/.config/herdr}"
PLUGINS_STATE_FILE="$CONFIG_DIR/plugins.json"

if ! command -v herdr >/dev/null 2>&1; then
  echo "Error: herdr CLI not found in PATH" >&2
  exit 1
fi

if ! command -v yq >/dev/null 2>&1; then
  echo "Error: 'yq' is required to parse $MANIFEST_FILE but was not found in PATH." >&2
  echo "Please install yq (e.g. 'sudo pacman -S yq' on Arch or 'brew install yq' on macOS)." >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq not found in PATH" >&2
  exit 1
fi

if [[ ! -f "$MANIFEST_FILE" ]]; then
  echo "Error: plugins manifest not found at $MANIFEST_FILE" >&2
  exit 1
fi

echo "Syncing Herdr plugins from $MANIFEST_FILE..."

# Note: this avoids `declare -A` (associative arrays) so it works with the
# stock bash 3.2 shipped on macOS, not just bash 4+ (e.g. on Arch Linux).

# Returns 0 if $1 is present among the newline-separated entries in $2.
contains_entry() {
  local needle="$1" haystack="$2" line
  while IFS= read -r line; do
    [[ "$line" == "$needle" ]] && return 0
  done <<<"$haystack"
  return 1
}

# Collect installed plugins (owner/repo)
installed_plugins=""
if [[ -f "$PLUGINS_STATE_FILE" ]]; then
  installed_plugins="$(jq -r '.[] | select(.source != null and .source.owner != null and .source.repo != null) | "\(.source.owner)/\(.source.repo)"' "$PLUGINS_STATE_FILE" 2>/dev/null || true)"
fi

# Track desired plugins
desired_plugins=""

# Process each entry from YAML
while IFS=$'\t' read -r repo ref; do
  [[ -z "$repo" || "$repo" == "null" ]] && continue
  desired_plugins="$desired_plugins$repo"$'\n'

  if contains_entry "$repo" "$installed_plugins"; then
    echo "✓ $repo is already installed"
  else
    echo "→ Installing missing plugin: $repo..."
    if [[ -n "$ref" && "$ref" != "null" ]]; then
      herdr plugin install "$repo" --ref "$ref" --yes
    else
      herdr plugin install "$repo" --yes
    fi
  fi
done < <(yq -r '.plugins[] | [(.repo // .), (.ref // "")] | join("\t")' "$MANIFEST_FILE")

# Check for unmanaged/extra plugins to tidy
while IFS= read -r installed_repo; do
  [[ -z "$installed_repo" ]] && continue
  if ! contains_entry "$installed_repo" "$desired_plugins"; then
    echo "⚠ Unmanaged plugin detected: $installed_repo"
    read -r -p "Remove unmanaged plugin $installed_repo? [y/N] " response </dev/tty || response="n"
    if [[ "$response" =~ ^[Yy]$ ]]; then
      echo "→ Uninstalling $installed_repo..."
      herdr plugin uninstall "$installed_repo"
    fi
  fi
done <<<"$installed_plugins"

echo "Herdr plugin tidy complete."
