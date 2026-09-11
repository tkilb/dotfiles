vim() {
  # Note: suspending/backgrounding jobs invoked from *any* shell function
  # (this one included) hits a known zsh limitation where `jobs` shows
  # blank command text (see .feature.jobs.sh for the fix/explanation).
  # The trailing `return $?` on each branch just propagates the wrapped
  # command's real exit status.
  if command -v nvim &>/dev/null; then
    # Track nvim's final cwd (see nvim/lua/config/autocmds.lua) and cd the
    # shell into it on exit, so leaving nvim leaves you where it left off.
    local nvim_cwd_file
    nvim_cwd_file="$(mktemp -t "nvim-cwd.XXXXXX")"
    NVIM_CWD_FILE="$nvim_cwd_file" nvim "$@"
    local nvim_status=$?
    if [ -s "$nvim_cwd_file" ]; then
      local nvim_cwd
      nvim_cwd="$(cat "$nvim_cwd_file")"
      [ "$nvim_cwd" != "$PWD" ] && [ -d "$nvim_cwd" ] && builtin cd -- "$nvim_cwd"
    fi
    rm -f -- "$nvim_cwd_file"
    return $nvim_status
  elif command -v vim &>/dev/null; then
    command vim "$@"
    return $?
  else
    vi "$@"
    return $?
  fi
}

# '-' opens the current directory in yazi
alias -- '-'='vim .'
