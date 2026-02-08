export EDITOR="nvim"
export GIT_EDITOR="nvim"
export GPG_TTY=$(tty) # For gpg to work properly with git
export LESS=-Ri       # Case insensitive less with color
export VISUAL="nvim"

if [ "$OS" = "mac" ]; then
    # Move next only if `homebrew` is installed
    if command -v brew >/dev/null 2>&1; then
        # Load rupa's z if installed
        [ -f $(brew --prefix)/etc/profile.d/z.sh ] && source $(brew --prefix)/etc/profile.d/z.sh
    fi
fi
