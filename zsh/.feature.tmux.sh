if [ -z $TMUX_PATH ]; then
    TMUX_PATH=$(which tmux)
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
