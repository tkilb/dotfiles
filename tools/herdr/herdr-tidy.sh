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

# Collect installed plugins (owner/repo)
declare -A installed_plugins=()
if [[ -f "$PLUGINS_STATE_FILE" ]]; then
  while IFS= read -r plugin_repo; do
    [[ -n "$plugin_repo" ]] && installed_plugins["$plugin_repo"]=1
  done < <(jq -r '.[] | select(.source != null and .source.owner != null and .source.repo != null) | "\(.source.owner)/\(.source.repo)"' "$PLUGINS_STATE_FILE" 2>/dev/null || true)
fi

# Track desired plugins
declare -A desired_plugins=()

# Process each entry from YAML
while IFS=$'\t' read -r repo ref; do
  [[ -z "$repo" || "$repo" == "null" ]] && continue
  desired_plugins["$repo"]=1

  if [[ -n "${installed_plugins[$repo]:-}" ]]; then
    echo "✓ $repo is already installed"
  else
    echo "→ Installing missing plugin: $repo..."
    if [[ -n "$ref" && "$ref" != "null" ]]; then
      herdr plugin install --yes --ref "$ref" "$repo"
    else
      herdr plugin install --yes "$repo"
    fi
  fi
done < <(yq -r '.plugins[] | if type == "string" then [., ""] else [.repo, (.ref // "")] end | @tsv' "$MANIFEST_FILE")

# Check for unmanaged/extra plugins to tidy
for installed_repo in "${!installed_plugins[@]}"; do
  if [[ -z "${desired_plugins[$installed_repo]:-}" ]]; then
    echo "⚠ Unmanaged plugin detected: $installed_repo"
    read -r -p "Remove unmanaged plugin $installed_repo? [y/N] " response </dev/tty || response="n"
    if [[ "$response" =~ ^[Yy]$ ]]; then
      echo "→ Uninstalling $installed_repo..."
      herdr plugin uninstall "$installed_repo"
    fi
  fi
done

echo "Herdr plugin tidy complete."
