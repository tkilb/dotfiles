alias cls='clear'
alias dir='pwd -P | pbcopy'
alias grepi="grep -i $1"

alias pingg='ping 8.8.8.8'
alias pwdp='pwd -P'
alias xrm="xargs rm $@"

if [[ "$(uname)" != "Darwin" ]]; then
  alias pbcopy='wl-copy'
  alias pbpaste='wl-paste'
fi

size() {
  ls -lAh $1
  #ls -lAh $1 | awk '{print $2, "\t", $5, "\t", $9}'
}

sizeb() {
  ls -lA $1 | awk '{print $2, "\t", $5, "\t", $9}'
}
