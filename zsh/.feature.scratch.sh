scratch() {
  local _datestamp=$(date +"%Y%m%d-%H%M%S" | tr -d ':')
  local _name=${1:-$_datestamp}
  local _dir="$HOME/Scratch/scratch_$_name"
  mkdir $_dir
  cd $_dir
}

scratch-code() {
  local _datestamp=$(date +"%Y%m%d-%H%M%S" | tr -d ':')
  local _name=${1:-$_datestamp}
  local _dir="$HOME/Scratch/scratch_$_name"
  mkdir $_dir
  code $_dir
}

spike() {
  local _name=${1}
  local _dir="$HOME/Spikes/$_name"
  mkdir $_dir
  cd $_dir
}

unscratch() {
  rm -rf $HOME/Scratch/scratch_*
}
