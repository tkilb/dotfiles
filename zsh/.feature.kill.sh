alias kchrome="killall \"Google Chrome\""
alias killterm="killall Terminal"

killport() {
    kill $(lsof -t -i :$1)
}

killports() {
    kill $(lsof -t -i :3000)
    kill $(lsof -t -i :8080)
    kill $(lsof -t -i :7000)
    kill $(lsof -t -i :7007)
    kill $(lsof -t -i :7008)
    kill $(lsof -t -i :7009)
    kill $(lsof -t -i :7010)
    kill $(lsof -t -i :7011)
    kill $(lsof -t -i :7012)
    kill $(lsof -t -i :7013)
}
