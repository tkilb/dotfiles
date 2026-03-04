alias cls='clear'
alias dir='pwd -P | pbcopy'
alias epochdatelocal="date -j -f \"%Y%m%d%T\" \"\$(date \"+%Y%m%d00:00:00\")\" \"+%s\""
alias epochdateutc="date -j -f \"%Y%m%d%T%z\" \"\$(date \"+%Y%m%d00:00:00-0000\")\" \"+%s\""
alias epochread="date -r"
alias epochtime="date +%s"
alias grepi="grep -i $1"
alias join="sed 's/^\ *//g' | tr '\n' ' '"
alias joinf="sed 's/^\ *//g' | cut -d\" \" -f1 | tr '\n' ' '"
alias joinfnh="sed 's/^\ *//g' | tail -n +2 | cut -d\" \" -f1 | tr '\n' ' '"
alias l1='ls -1'
alias lastdir='ls -1 | tail -n 1'
alias lgrep="ls -1A | grep -i $@"
alias lh='ls -lad .*'
alias la='ls -lA'
alias cls='clear'
alias dir='pwd -P | pbcopy'
alias epochdatelocal="date -j -f \"%Y%m%d%T\" \"\$(date \"+%Y%m%d00:00:00\")\" \"+%s\""
alias epochdateutc="date -j -f \"%Y%m%d%T%z\" \"\$(date \"+%Y%m%d00:00:00-0000\")\" \"+%s\""
alias epochread="date -r"
alias epochtime="date +%s"
alias grepi="grep -i $1"
alias join="sed 's/^\ *//g' | tr '\n' ' '"
alias joinf="sed 's/^\ *//g' | cut -d\" \" -f1 | tr '\n' ' '"
alias joinfnh="sed 's/^\ *//g' | tail -n +2 | cut -d\" \" -f1 | tr '\n' ' '"
alias lastdir='ls -1 | tail -n 1'
alias lgrep="ls -1A | grep -i $@"
alias lh='ls -lad .*'
alias la='ls -lA'
alias ll='ls -l'
alias ncode='kcode && code . || code .'
alias nx='npx nx'
alias p='prettier --write'
alias pingg='ping 8.8.8.8'
alias pwdp='pwd -P'
alias sri='openssl dgst -sha384 -binary | openssl base64 -A | sed -e "s/^/sha384-/;"'
alias uuid16="python -c 'import sys,uuid; sys.stdout.write(uuid.uuid4().hex)' | cut -c1-16 | pbcopy && pbpaste"
alias uuid="python -c 'import sys,uuid; sys.stdout.write(uuid.uuid4().hex)' | pbcopy && pbpaste && echo"
alias xrm="xargs rm $@"

alias mrm="rm ...makefile"
alias mm="m m"

if [[ "$(uname)" != "Darwin" ]]; then
  alias pbcopy='wl-copy'
  alias pbpaste='wl-paste'
fi

lorem() {
  echo 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.' | pbcopy
  echo Lorem copied to clipboard
}

psp() {
  ps aux | grep $1 >...tmp.txt | code -
}

m() {
  if [ -n "$1" ]; then
    /usr/bin/make --file ...makefile $@
  else
    test -f ...makefile || echo 'm:\n\t' >...makefile
    code ...makefile
  fi
}

size() {
  ls -lAh $1
  #ls -lAh $1 | awk '{print $2, "\t", $5, "\t", $9}'
}

sizeb() {
  ls -lA $1 | awk '{print $2, "\t", $5, "\t", $9}'
}
alias ll='ls -l'
alias ncode='kcode && code . || code .'
alias nx='npx nx'
alias p='prettier --write'
alias pingg='ping 8.8.8.8'
alias pwdp='pwd -P'
alias sri='openssl dgst -sha384 -binary | openssl base64 -A | sed -e "s/^/sha384-/;"'
alias uuid16="python -c 'import sys,uuid; sys.stdout.write(uuid.uuid4().hex)' | cut -c1-16 | pbcopy && pbpaste"
alias uuid="python -c 'import sys,uuid; sys.stdout.write(uuid.uuid4().hex)' | pbcopy && pbpaste && echo"
alias xrm="xargs rm $@"
alias mrm="rm ...makefile"
alias mm="m m"

if [[ "$(uname)" != "Darwin" ]]; then
  alias pbcopy='wl-copy'
  alias pbpaste='wl-paste'
fi

lorem() {
  echo 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.' | pbcopy
  echo Lorem copied to clipboard
}

psp() {
  ps aux | grep $1 >...tmp.txt | code -
}

m() {
  if [ -n "$1" ]; then
    /usr/bin/make --file ...makefile $@
  else
    test -f ...makefile || echo 'm:\n\t' >...makefile
    code ...makefile
  fi
}

size() {
  ls -lAh $1
  #ls -lAh $1 | awk '{print $2, "\t", $5, "\t", $9}'
}

sizeb() {
  ls -lA $1 | awk '{print $2, "\t", $5, "\t", $9}'
}
