alias fixlock="git checkout origin/main -- package-lock.json || git checkout origin/master -- package-lock.json && npm install"
alias npm-reinstall="rm -rf node_modules ; npm install"
alias npm-scripts="cat package.json | jq .scripts"

npm-find() {
  open "https://www.npmjs.com/search?q=$1"
}


@t() { npm install --save-dev @types/$1 }

@tu() { npm uninstall --save-dev @types/$1 }

u() {
  for p in "$@"
  do
    # npm uninstall --save-dev $p
    # npm uninstall --save $p
    npm uninstall $p
  done
}

