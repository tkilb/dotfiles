#!/usr/bin/env bash
# Build ec (easy-conflict) with the local arrow-key patch.
#
# Usage: ec-build [--stock] [--force]
#   --stock  build upstream ec without arrow-keys.patch (fallback)
#   --force  rebuild even if the installed build is current
#
# Env:
#   EC_INSTALL_DIR  install directory (default: ~/.local/bin)
#   DOTFILES        dotfiles checkout (default: ~/.dotfiles)

set -euo pipefail

EC_VERSION="v0.4.4"
EC_REPO="https://github.com/chojs23/ec.git"
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
PATCH="$DOTFILES/tools/ec/arrow-keys.patch"
INSTALL_DIR="${EC_INSTALL_DIR:-$HOME/.local/bin}"
STAMP_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/ec-build"

stock=false
force=false
for arg in "$@"; do
  case "$arg" in
    --stock) stock=true ;;
    --force) force=true ;;
    *)
      echo "Unknown argument: $arg" >&2
      exit 2
      ;;
  esac
done

for cmd in go git cksum; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "Error: $cmd is required but not installed." >&2
    exit 1
  }
done

if $stock; then
  variant="stock"
else
  [[ -f "$PATCH" ]] || {
    echo "Error: patch not found at $PATCH" >&2
    exit 1
  }
  variant="patched-$(cksum <"$PATCH" | cut -d' ' -f1)"
fi

stamp="$EC_VERSION $variant"
stamp_file="$STAMP_DIR/stamp"

if ! $force && [[ -x "$INSTALL_DIR/ec" && -f "$stamp_file" ]] &&
  [[ "$(cat "$stamp_file")" == "$stamp" ]]; then
  echo "ec is up to date ($stamp)."
  exit 0
fi

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

echo "Cloning ec $EC_VERSION..."
git -c advice.detachedHead=false clone --quiet --depth 1 --branch "$EC_VERSION" "$EC_REPO" "$work/src"

if ! $stock; then
  echo "Applying arrow-keys.patch..."
  git -C "$work/src" apply "$PATCH"
fi

echo "Building..."
go build -C "$work/src" -o "$work/ec" ./cmd/ec

mkdir -p "$INSTALL_DIR" "$STAMP_DIR"
install -m 0755 "$work/ec" "$INSTALL_DIR/ec"
printf '%s\n' "$stamp" >"$stamp_file"

echo "Installed ec ($stamp) to $INSTALL_DIR/ec"
