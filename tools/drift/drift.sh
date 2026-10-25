#!/usr/bin/env bash
#
# drift - Check git repository status and divergence across ~/.dotfiles, ~/.gamefiles, and ~/Git/*
#

set -euo pipefail

# Self-symlink to ~/.local/bin/drift if not already present
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
BIN_SYMLINK="$HOME/.local/bin/drift"
if [[ ! -e "$BIN_SYMLINK" ]]; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$SCRIPT_PATH" "$BIN_SYMLINK"
fi

# Options & defaults
SHOW_ALL=false
DO_FETCH=true
FETCH_TIMEOUT=5
PRINT_JSON=false

usage() {
  cat <<'EOF'
Usage: drift [OPTIONS]

Audit git repositories across ~/.dotfiles, ~/.gamefiles, and ~/Git/ (1 level deep)
for uncommitted changes and divergence from remote origin.

Options:
  -a, --all         Show all scanned repositories (default: only show repos with drift)
  -n, --no-fetch    Skip background git fetch (check only against local/cached refs)
  -t, --timeout SEC Remote fetch timeout in seconds per repository (default: 5)
  -h, --help        Show this help message
EOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -a|--all)
      SHOW_ALL=true
      shift
      ;;
    -n|--no-fetch)
      DO_FETCH=false
      shift
      ;;
    -t|--timeout)
      FETCH_TIMEOUT="$2"
      shift 2
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      ;;
  esac
done

# Colors (disabled if not a tty)
if [[ -t 1 ]]; then
  C_RESET="\033[0m"
  C_BOLD="\033[1m"
  C_DIM="\033[2m"
  C_RED="\033[31m"
  C_GREEN="\033[32m"
  C_YELLOW="\033[33m"
  C_ORANGE="\033[38;5;208m"
  C_BLUE="\033[34m"
  C_MAGENTA="\033[35m"
  C_CYAN="\033[36m"
else
  C_RESET=""
  C_BOLD=""
  C_DIM=""
  C_RED=""
  C_GREEN=""
  C_YELLOW=""
  C_ORANGE=""
  C_BLUE=""
  C_MAGENTA=""
  C_CYAN=""
fi

# Discover repositories
REPOS=()

# 1. ~/.dotfiles
if [[ -d "$HOME/.dotfiles/.git" ]]; then
  REPOS+=("$HOME/.dotfiles")
fi

# 2. ~/.gamefiles (optional - ignore if DNE)
if [[ -d "$HOME/.gamefiles/.git" ]]; then
  REPOS+=("$HOME/.gamefiles")
fi

# 3. ~/Git/ (flat 1-level deep)
GIT_DIR="$HOME/Git"
if [[ -d "$GIT_DIR" ]]; then
  # Nullglob to avoid literal wildcard if empty
  shopt -s nullglob
  for dir in "$GIT_DIR"/*; do
    if [[ -d "$dir" ]]; then
      REPOS+=("$dir")
    fi
  done
  shopt -u nullglob
fi

if [[ ${#REPOS[@]} -eq 0 ]]; then
  echo -e "${C_YELLOW}No git repositories found to inspect.${C_RESET}"
  exit 0
fi

# Parallel background fetch if requested
TEMP_DIR="$(mktemp -d /tmp/drift.XXXXXX)"
cleanup() {
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

if [[ "$DO_FETCH" == "true" ]]; then
  echo -ne "${C_DIM}Fetching remote status in parallel (timeout: ${FETCH_TIMEOUT}s)...${C_RESET}\r"
  FETCH_PIDS=()
  REPO_INDEX=0
  for repo in "${REPOS[@]}"; do
    if [[ -d "$repo/.git" ]]; then
      (
        # Attempt fetch with timeout if available
        if command -v timeout >/dev/null 2>&1; then
          timeout "$FETCH_TIMEOUT" git -C "$repo" fetch --quiet --prune >/dev/null 2>&1 || true
        else
          # Fallback without timeout tool
          git -C "$repo" fetch --quiet --prune >/dev/null 2>&1 || true
        fi
      ) &
      FETCH_PIDS+=($!)
    fi
    REPO_INDEX=$((REPO_INDEX + 1))
  done

  # Wait for all background fetches to finish
  for pid in "${FETCH_PIDS[@]}"; do
    wait "$pid" 2>/dev/null || true
  done
  # Clear the fetch notice
  printf "%-70s\r" " "
fi

# Collect audit records
# Format stored per item in temp file:
# PATH|BRANCH|UNCOMMITTED_DISPLAY|SYNC_DISPLAY|HAS_DRIFT|STATUS_TYPE
RESULTS_FILE="$TEMP_DIR/results.txt"

for repo in "${REPOS[@]}"; do
  # Pretty display path (replacing $HOME with ~)
  display_path="${repo/#$HOME/\~}"

  if [[ ! -d "$repo/.git" ]]; then
    # Not a git repo
    echo "$display_path|-|not a git repo|missing .git|true|error" >> "$RESULTS_FILE"
    continue
  fi

  # Current branch or detached HEAD
  branch="$(git -C "$repo" branch --show-current 2>/dev/null || true)"
  if [[ -z "$branch" ]]; then
    # Could be detached HEAD
    branch="$(git -C "$repo" rev-parse --short HEAD 2>/dev/null || echo "empty")"
    branch="detached($branch)"
  fi

  # Remote origin check
  has_origin=true
  if ! git -C "$repo" remote get-url origin >/dev/null 2>&1; then
    has_origin=false
  fi

  # Uncommitted changes check (staged, unstaged, untracked)
  # git status --porcelain:
  # XY filename
  # X = staged status, Y = unstaged status, ?? = untracked
  staged_count=0
  unstaged_count=0
  untracked_count=0

  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    x="${line:0:1}"
    y="${line:1:1}"

    if [[ "$x" == "?" && "$y" == "?" ]]; then
      untracked_count=$((untracked_count + 1))
    else
      if [[ "$x" != " " && "$x" != "?" ]]; then
        staged_count=$((staged_count + 1))
      fi
      if [[ "$y" != " " && "$y" != "?" ]]; then
        unstaged_count=$((unstaged_count + 1))
      fi
    fi
  done < <(git -C "$repo" status --porcelain 2>/dev/null || true)

  # Build uncommitted summary
  uncommitted_parts=()
  [[ $staged_count -gt 0 ]] && uncommitted_parts+=("${staged_count} staged")
  [[ $unstaged_count -gt 0 ]] && uncommitted_parts+=("${unstaged_count} modified")
  [[ $untracked_count -gt 0 ]] && uncommitted_parts+=("${untracked_count} untracked")

  if [[ ${#uncommitted_parts[@]} -gt 0 ]]; then
    has_uncommitted=true
    uncommitted_str=""
    for part in "${uncommitted_parts[@]}"; do
      if [[ -z "$uncommitted_str" ]]; then
        uncommitted_str="$part"
      else
        uncommitted_str="$uncommitted_str, $part"
      fi
    done
  else
    has_uncommitted=false
    uncommitted_str="clean"
  fi

  # Remote sync check
  has_sync_drift=false
  sync_str=""

  if [[ "$has_origin" == "false" ]]; then
    has_sync_drift=true
    sync_str="no origin"
  else
    # Check upstream
    upstream="$(git -C "$repo" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null || true)"
    if [[ -z "$upstream" ]]; then
      # No upstream tracked branch
      # Check if origin has matching branch
      if git -C "$repo" rev-parse --verify "origin/$branch" >/dev/null 2>&1; then
        upstream="origin/$branch"
      fi
    fi

    if [[ -z "$upstream" ]]; then
      has_sync_drift=true
      sync_str="unpushed branch"
    else
      rev_counts="$(git -C "$repo" rev-list --left-right --count HEAD...$upstream 2>/dev/null || echo "0	0")"
      ahead="$(echo "$rev_counts" | awk '{print $1}')"
      behind="$(echo "$rev_counts" | awk '{print $2}')"

      if [[ "$ahead" -gt 0 && "$behind" -gt 0 ]]; then
        has_sync_drift=true
        sync_str="diverged (+${ahead}/-${behind})"
      elif [[ "$ahead" -gt 0 ]]; then
        has_sync_drift=true
        sync_str="ahead (+${ahead})"
      elif [[ "$behind" -gt 0 ]]; then
        has_sync_drift=true
        sync_str="behind (-${behind})"
      else
        if [[ "$has_uncommitted" == "true" ]]; then
          sync_str="dirty"
        else
          sync_str="synced"
        fi
      fi
    fi
  fi

  has_drift=false
  if [[ "$has_uncommitted" == "true" || "$has_sync_drift" == "true" ]]; then
    has_drift=true
  fi

  echo "$display_path|$branch|$uncommitted_str|$sync_str|$has_drift|ok" >> "$RESULTS_FILE"
done

# Calculate column widths dynamically
max_path_len=4
max_branch_len=6
max_uncommitted_len=11
max_sync_len=4

count_total=0
count_drift=0

while IFS='|' read -r r_path r_branch r_uncommitted r_sync r_drift r_status; do
  [[ -z "$r_path" ]] && continue
  count_total=$((count_total + 1))
  if [[ "$r_drift" == "true" ]]; then
    count_drift=$((count_drift + 1))
  fi

  if [[ "$SHOW_ALL" == "true" || "$r_drift" == "true" ]]; then
    ((${#r_path} > max_path_len)) && max_path_len=${#r_path}
    ((${#r_branch} > max_branch_len)) && max_branch_len=${#r_branch}
    ((${#r_uncommitted} > max_uncommitted_len)) && max_uncommitted_len=${#r_uncommitted}
    ((${#r_sync} > max_sync_len)) && max_sync_len=${#r_sync}
  fi
done < "$RESULTS_FILE"

# If no drift found and not --all
if [[ "$count_drift" -eq 0 && "$SHOW_ALL" == "false" ]]; then
  echo -e "${C_GREEN}✓ All ${count_total} repositories are clean and synchronized with origin.${C_RESET}"
  exit 0
fi

# Print table header
printf "${C_BOLD}%-${max_path_len}s   %-${max_branch_len}s   %-${max_uncommitted_len}s   %-${max_sync_len}s${C_RESET}\n" \
  "PATH" "BRANCH" "UNCOMMITTED" "SYNC"

# Print separator line
sep_path=$(printf '%*s' "$max_path_len" '' | tr ' ' '-')
sep_branch=$(printf '%*s' "$max_branch_len" '' | tr ' ' '-')
sep_uncommitted=$(printf '%*s' "$max_uncommitted_len" '' | tr ' ' '-')
sep_sync=$(printf '%*s' "$max_sync_len" '' | tr ' ' '-')
printf "${C_DIM}%s   %s   %s   %s${C_RESET}\n" "$sep_path" "$sep_branch" "$sep_uncommitted" "$sep_sync"

# Print rows
while IFS='|' read -r r_path r_branch r_uncommitted r_sync r_drift r_status; do
  [[ -z "$r_path" ]] && continue

  if [[ "$SHOW_ALL" == "false" && "$r_drift" == "false" ]]; then
    continue
  fi

  # Path coloring
  color_path="${C_BOLD}"
  if [[ "$r_status" == "error" ]]; then
    color_path="${C_RED}"
  elif [[ "$r_drift" == "true" ]]; then
    color_path="${C_CYAN}"
  fi

  # Uncommitted coloring
  color_uncommitted="${C_GREEN}"
  if [[ "$r_uncommitted" != "clean" ]]; then
    color_uncommitted="${C_YELLOW}"
  fi

  # Sync coloring
  color_sync="${C_GREEN}"
  if [[ "$r_sync" == "synced" ]]; then
    color_sync="${C_GREEN}"
  elif [[ "$r_sync" == "dirty" ]]; then
    color_sync="${C_ORANGE}"
  elif [[ "$r_sync" =~ ^ahead ]]; then
    color_sync="${C_BLUE}"
  elif [[ "$r_sync" =~ ^behind ]]; then
    color_sync="${C_MAGENTA}"
  elif [[ "$r_sync" =~ ^diverged ]]; then
    color_sync="${C_RED}"
  elif [[ "$r_sync" == "no origin" || "$r_sync" == "missing .git" ]]; then
    color_sync="${C_RED}"
  else
    color_sync="${C_YELLOW}"
  fi

  printf "${color_path}%-${max_path_len}s${C_RESET}   %-${max_branch_len}s   ${color_uncommitted}%-${max_uncommitted_len}s${C_RESET}   ${color_sync}%-${max_sync_len}s${C_RESET}\n" \
    "$r_path" "$r_branch" "$r_uncommitted" "$r_sync"
done < "$RESULTS_FILE"

echo ""
if [[ "$count_drift" -gt 0 ]]; then
  echo -e "${C_DIM}Showing ${count_drift} of ${count_total} repositories with drift. (Use -a/--all to show all repos)${C_RESET}"
else
  echo -e "${C_DIM}Showing all ${count_total} repositories.${C_RESET}"
fi
