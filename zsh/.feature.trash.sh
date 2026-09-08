trash() {
  case "$1" in
  -r | --restore)
    shift
    command trash-restore "$@"
    ;;
  -l | --list)
    shift
    command trash-list "$@"
    ;;
  -d | --delete)
    shift
    if [ $# -eq 0 ]; then
      echo "Error: Please specify which file to permanently delete."
      return 1
    fi
    command trash-rm "$@"
    ;;
  -e | --empty)
    shift
    read -q "confirm?Are you sure you want to permanently empty the trash? (y/N): "
    echo ""
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      command trash-empty "$@"
    else
      echo "Operation canceled."
    fi
    ;;
  -D | --downloads)
    shift
    if [ -d "$HOME/Downloads" ]; then
      # (D) includes hidden files, (N) prevents "no match" errors
      local files=("$HOME/Downloads"/*(DN))
      if [ ${#files} -gt 0 ]; then
        command trash-put "${files[@]}"
      fi
    fi
    ;;
  -S | --staging)
    shift
    if [ -d "$HOME/Staging" ]; then
      local files=("$HOME/Staging"/*(DN))
      if [ ${#files} -gt 0 ]; then
        command trash-put "${files[@]}"
      fi
    fi
    ;;
  -h | --help)
    echo "Usage: trash [OPTION] [FILE]..."
    echo "  -r, --restore     Restore files"
    echo "  -l, --list        List trash"
    echo "  -d, --delete      Delete a specific file permanently"
    echo "  -e, --empty       Empty trash bin"
    echo "  -D, --downloads   Trash everything inside ~/Downloads"
    echo "  -S, --staging     Trash everything inside ~/Staging"
    echo "  -h, --help        Show this help"
    ;;
  *)
    if [ $# -gt 0 ]; then
      command trash-put "$@"
    fi
    ;;
  esac
}

_trash_completion() {
  local context state state_descr line
  typeset -A opt_args

  _arguments -s : \
    '(-r --restore)'{-r,--restore}'[Interactive restore of trashed files]' \
    '(-l --list)'{-l,--list}'[List files currently in the trash]' \
    '(-d --delete)'{-d,--delete}'[Permanently delete a specific file from the trash]:file:_files' \
    '(-e --empty)'{-e,--empty}'[Empty the trash bin completely]' \
    '(-D --downloads)'{-D,--downloads}'[Trash everything inside ~/Downloads]' \
    '(-S --staging)'{-S,--staging}'[Trash everything inside ~/Staging]' \
    '(-h --help)'{-h,--help}'[Show the help menu]' \
    '*:file:_files'
}
compdef _trash_completion trash

alias t="trash"
