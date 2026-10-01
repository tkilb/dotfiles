tt() {
  if [[ $# -eq 0 ]]; then
    lazytask
  else
    task "$@"
  fi
}

alias task-purge='task status:deleted purge'
