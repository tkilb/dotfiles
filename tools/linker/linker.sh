#!/usr/bin/env bash

set -euo pipefail

# Load environment variables from ~/.profile if it exists
if [[ -f ~/.profile ]]; then
  source ~/.profile
fi

# Self-link to ~/.local/bin/linker if not already symlinked
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
BIN_LINK="$HOME/.local/bin/linker"
if [[ ! -e "$BIN_LINK" ]]; then
  mkdir -p "$HOME/.local/bin"
  ln -s "$SCRIPT_PATH" "$BIN_LINK"
  echo "Created symlink: $BIN_LINK -> $SCRIPT_PATH"
fi

# Resolve symlink to get actual script location
SCRIPT_REAL_PATH="$(readlink "${BASH_SOURCE[0]}" || echo "${BASH_SOURCE[0]}")"
if [[ "$SCRIPT_REAL_PATH" != /* ]]; then
  # Relative symlink - resolve from script directory
  SCRIPT_REAL_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd "$(dirname "$SCRIPT_REAL_PATH")" && pwd)/$(basename "$SCRIPT_REAL_PATH")"
fi
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_REAL_PATH")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Try to read config from ~/.config/linker/linker.yaml first
YAML_FILE="$HOME/.config/linker/linker.yaml"

# Fallback to ~/.dotfiles/linker/linker.yaml if not found
if [[ ! -f "$YAML_FILE" ]]; then
  YAML_FILE="$HOME/.dotfiles/linker/linker.yaml"
fi

if [[ ! -f "$YAML_FILE" ]]; then
  echo "Error: linker.yaml not found at ~/.config/linker/linker.yaml or ~/.dotfiles/linker/linker.yaml"
  exit 1
fi

# Check if MACHINE is set
if [[ -z "${MACHINE:-}" ]]; then
  echo "Error: MACHINE environment variable is not set, configure this in ~/.profile"
  exit 1
fi

# Function to process each entry
function process_entry() {
  local name="$current_name"
  local path="$current_path"
  local -a machines=("${current_machines[@]}")

  # Check if machine matches (if MACHINE is set and machines array is not empty)
  if [[ -n "${MACHINE:-}" ]] && [[ ${#machines[@]} -gt 0 ]]; then
    local machine_match=false
    for m in "${machines[@]}"; do
      if [[ "$m" == "$MACHINE" ]]; then
        machine_match=true
        break
      fi
    done

    if [[ "$machine_match" == false ]]; then
      echo "Skipping $name (machine $MACHINE not in allowed list)"
      return
    fi
  fi

  # Check if local file or folder exists
  local source_path="$DOTFILES_DIR/$name"
  if [[ ! -e "$source_path" ]]; then
    echo "Skipping $name (local file or folder does not exist)"
    return
  fi

  # Expand path (handle ~)
  local target_path="${path/#\~/$HOME}"

  # Create parent directory if it doesn't exist
  local parent_dir="$(dirname "$target_path")"
  if [[ ! -d "$parent_dir" ]]; then
    echo "Creating parent directory: $parent_dir"
    mkdir -p "$parent_dir"
  fi

  # Remove existing symlink or warn about existing file/directory
  if [[ -L "$target_path" ]]; then
    echo "Removing existing symlink: $target_path"
    rm "$target_path"
  elif [[ -e "$target_path" ]]; then
    echo "Warning: $target_path already exists and is not a symlink. Skipping."
    return
  fi

  # Create symlink
  echo "Creating symlink: $target_path -> $source_path"
  ln -s "$source_path" "$target_path"
}

# Parse YAML and create symlinks
current_name=""
current_path=""
current_machines=()
in_machines=false

while IFS= read -r line; do
  # Skip comments and empty lines
  [[ "$line" =~ ^[[:space:]]*# ]] && continue
  [[ -z "${line// /}" ]] && continue

  # Check for new entry (starts with "- name:")
  if [[ "$line" =~ ^-[[:space:]]+name:[[:space:]]+(.+)$ ]]; then
    # Process previous entry if exists
    if [[ -n "$current_name" ]]; then
      process_entry
    fi

    # Start new entry
    current_name="${BASH_REMATCH[1]}"
    current_path=""
    current_machines=()
    in_machines=false

  # Check for path
  elif [[ "$line" =~ ^[[:space:]]+path:[[:space:]]+(.+)$ ]]; then
    current_path="${BASH_REMATCH[1]}"

  # Check for machines section
  elif [[ "$line" =~ ^[[:space:]]+machines:[[:space:]]*$ ]]; then
    in_machines=true

  # Check for machine list item
  elif [[ "$in_machines" == true && "$line" =~ ^[[:space:]]+-[[:space:]]+(.+)$ ]]; then
    current_machines+=("${BASH_REMATCH[1]}")
  fi
done <"$YAML_FILE"

# Process last entry
if [[ -n "$current_name" ]]; then
  process_entry
fi
