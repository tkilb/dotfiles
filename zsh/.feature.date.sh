alias epochdatelocal="date -j -f \"%Y%m%d%T\" \"\$(date \"+%Y%m%d00:00:00\")\" \"+%s\""
alias epochdateutc="date -j -f \"%Y%m%d%T%z\" \"\$(date \"+%Y%m%d00:00:00-0000\")\" \"+%s\""
alias epochread="date -r"
alias epochtime="date +%s"
