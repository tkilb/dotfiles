t() {
  if [[ $# -eq 0 ]]; then
    taskwarrior-tui
  else
    task "$@"
  fi
}

alias task-purge='task status:deleted purge'
