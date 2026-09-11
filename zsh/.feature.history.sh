hist() {
  [ -z "$2" ] && history | grep ${1-''} | tail -n 10 || history | grep ${1-''} | tail -n $2
}

alias h='hist'
