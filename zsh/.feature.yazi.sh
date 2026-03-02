function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# Alias for quick file system navigation.
# '+' opens the current directory in yazi, '-' opens it in nvim oil.
alias -- '+'='y'
alias -- '-'='nvim .'
