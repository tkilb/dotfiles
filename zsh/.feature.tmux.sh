if [ -z $TMUX_PATH ]; then
    TMUX_PATH=$(which tmux)
fi

##################################################
# Auto-start tmux in Kitty
##################################################
# Only for kitty (checked via TERM), only if not already inside tmux,
# and only for interactive shells so this doesn't hijack `kitty +kitten ...`
# or non-interactive scripts run through kitty.
if [[ "$TERM" == "xterm-kitty" ]] && [ -z "$TMUX" ] && [[ $- == *i* ]]; then
    exec $TMUX_PATH new-session -A -s main
fi

##################################################
# Tmuxifier Setup
##################################################
# Install tmuxifier if it is missing
if ! command -v tmuxifier >/dev/null 2>&1; then
    git clone https://github.com/jimeh/tmuxifier.git ~/.tmuxifier
fi

# Investigate
# eval "$(tmuxifier init -)"

# tmux() {
#     if [ $# -eq 0 ]; then
#         eval $TMUX_PATH
#         return
#     fi
#
#     tmuxifier "$@"
# }
