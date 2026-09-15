#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Rofi Desktop Application Launcher with Web Search Fallback
#
# Usage in Hyprland / Rofi:
#   rofi -show launcher -modes "launcher:~/.config/rofi/scripts/launcher.sh"
#
# Behaviors:
#   1. No arguments: Lists desktop applications with icons and launch commands.
#   2. Application selected: Launches the selected application detached.
#   3. Custom input entered: Falls back to Google web search or direct URL
#      navigation in default browser ($BROWSER or zen), then focuses workspace 2.
# -----------------------------------------------------------------------------

APP_DIRS=(
  "$HOME/.local/share/applications"
  "/usr/local/share/applications"
  "/usr/share/applications"
  "/var/lib/flatpak/exports/share/applications"
  "$HOME/.local/share/flatpak/exports/share/applications"
)

list_applications() {
  local valid_dirs=()
  for dir in "${APP_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
      valid_dirs+=("$dir")
    fi
  done

  if [[ ${#valid_dirs[@]} -eq 0 ]]; then
    return 0
  fi

  # Efficient single-pass gawk parser across all .desktop files with internal sorting
  find "${valid_dirs[@]}" -maxdepth 2 -type f -name "*.desktop" 2>/dev/null | {
    local desktop_files=()
    while IFS= read -r file; do
      desktop_files+=("$file")
    done
    if [[ ${#desktop_files[@]} -gt 0 ]]; then
      gawk '
        BEGIN {
          FS = "="
        }
        FNR == 1 {
          in_entry = 0
          name = ""
          icon = ""
          exec_cmd = ""
          no_display = 0
          hidden = 0
          app_type = ""
        }
        tolower($0) ~ /^\[desktop entry\]/ {
          in_entry = 1
          next
        }
        /^\[/ {
          in_entry = 0
        }
        in_entry && /^Name=/ && name == "" {
          sub(/^Name=/, "")
          name = $0
        }
        in_entry && /^Icon=/ && icon == "" {
          sub(/^Icon=/, "")
          icon = $0
        }
        in_entry && /^Exec=/ && exec_cmd == "" {
          sub(/^Exec=/, "")
          exec_cmd = $0
        }
        in_entry && tolower($0) ~ /^nodisplay=(true|1)/ {
          no_display = 1
        }
        in_entry && tolower($0) ~ /^hidden=(true|1)/ {
          hidden = 1
        }
        in_entry && /^Type=/ {
          sub(/^Type=/, "")
          app_type = $0
        }
        ENDFILE {
          if (in_entry != -1 && !no_display && !hidden && (app_type == "" || app_type == "Application") && name != "" && exec_cmd != "") {
            gsub(/%[a-zA-Z]/, "", exec_cmd)
            gsub(/^[ \t]+|[ \t]+$/, "", exec_cmd)
            if (!(name in apps)) {
              apps[name] = 1
              icons[name] = icon
              execs[name] = exec_cmd
            }
          }
        }
        END {
          n = asorti(apps, sorted_names, "@ind_str_asc")
          for (i = 1; i <= n; i++) {
            app_name = sorted_names[i]
            printf "%s\0icon\x1f%s\x1finfo\x1f%s\n", app_name, icons[app_name], execs[app_name]
          }
        }
      ' "${desktop_files[@]}"
    fi
  }
}

launch_fallback_search() {
  local query="${1:-}"
  if [[ -z "$query" ]]; then
    return 0
  fi

  local target_url=""
  local domain_regex='^([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}(:[0-9]{1,5})?(/.*)?$'
  local local_regex='^(localhost|127\.0\.0\.1|0\.0\.0\.0)(:[0-9]{1,5})?(/.*)?$'

  if [[ "$query" =~ ^https?:// ]]; then
    target_url="$query"
  elif [[ "$query" =~ $domain_regex ]] || [[ "$query" =~ $local_regex ]]; then
    target_url="https://${query}"
  else
    local encoded_query
    encoded_query="$(jq -rn --arg q "$query" '$q|@uri')"
    target_url="https://www.google.com/search?q=${encoded_query}"
  fi

  local browser="${BROWSER:-zen}"
  if command -v "$browser" >/dev/null 2>&1; then
    nohup "$browser" "$target_url" >/dev/null 2>&1 &
  else
    nohup xdg-open "$target_url" >/dev/null 2>&1 &
  fi

  # Locate where zen/browser is parked across workspaces and switch focus
  if command -v hyprctl >/dev/null 2>&1; then
    local zen_client
    zen_client="$(hyprctl clients -j 2>/dev/null | jq -c '[.[] | select((.class | ascii_downcase) | test("zen|browser"))] | first // empty')"

    local target_ws="2"
    local target_addr=""

    if [[ -n "$zen_client" ]]; then
      target_ws="$(echo "$zen_client" | jq -r '.workspace.id // 2')"
      target_addr="$(echo "$zen_client" | jq -r '.address // ""')"
    fi

    # Small detached delay ensures Rofi has unmapped and closed before focusing
    (
      sleep 0.05
      hyprctl dispatch workspace "$target_ws" >/dev/null 2>&1 || true
      if [[ -n "$target_addr" ]]; then
        hyprctl dispatch focuswindow "address:$target_addr" >/dev/null 2>&1 || true
      else
        hyprctl dispatch focuswindow "class:zen" >/dev/null 2>&1 || true
      fi
    ) >/dev/null 2>&1 &
  fi
}

get_app_workspace() {
  local selection="$1"
  local rofi_info="$2"
  local config_file="${HOME}/.config/hypr/app-workspaces.json"
  if [[ ! -f "$config_file" ]]; then
    config_file="${HOME}/.dotfiles/hypr/app-workspaces.json"
  fi

  if [[ ! -f "$config_file" ]]; then
    return 0
  fi

  local sel_lower
  sel_lower="$(echo "$selection" | tr '[:upper:]' '[:lower:]')"
  local info_lower
  info_lower="$(echo "$rofi_info" | tr '[:upper:]' '[:lower:]')"

  while read -r app ws; do
    [[ -z "$app" || -z "$ws" ]] && continue
    local app_lower
    app_lower="$(echo "$app" | tr '[:upper:]' '[:lower:]')"
    if [[ "$sel_lower" =~ $app_lower ]] || [[ "$info_lower" =~ $app_lower ]]; then
      echo "$ws"
      return 0
    fi
  done < <(jq -r 'to_entries[] | "\(.key) \(.value)"' "$config_file")
}

main() {
  if [[ $# -eq 0 ]]; then
    list_applications
    return 0
  fi

  local selection="$1"
  local rofi_info="${ROFI_INFO:-}"

  if [[ -n "$rofi_info" ]]; then
    # Application selected from desktop entries
    nohup bash -c "$rofi_info" >/dev/null 2>&1 &

    local target_ws
    target_ws="$(get_app_workspace "$selection" "$rofi_info")"
    if [[ -n "$target_ws" ]] && command -v hyprctl >/dev/null 2>&1; then
      (
        sleep 0.05
        hyprctl dispatch workspace "$target_ws" >/dev/null 2>&1 || true
      ) >/dev/null 2>&1 &
    fi
  else
    # Custom input submitted (search fallback)
    launch_fallback_search "$selection"
  fi
}

main "$@"
