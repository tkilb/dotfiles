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

alias sri='openssl dgst -sha384 -binary | openssl base64 -A | sed -e "s/^/sha384-/;"'
alias uuid16="uuidgen | tr -d '-' | tr '[:upper:]' '[:lower:]' | cut -c1-16 | tee >(pbcopy)"
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]' | tee >(pbcopy)"

lorem() {
  echo 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.' | pbcopy
  echo Lorem copied to clipboard
}
