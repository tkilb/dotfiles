alias mrm="rm ...makefile"
alias mm="m m"

m() {
  if [ -n "$1" ]; then
    /usr/bin/make --file ...makefile $@
  else
    test -f ...makefile || echo 'm:\n\t' >...makefile
    code ...makefile
  fi
}
