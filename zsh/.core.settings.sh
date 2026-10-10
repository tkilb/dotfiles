##################################################
# Set Key Environment Variables
##################################################
export EDITOR="nvim"
export GIT_EDITOR="nvim"
export GPG_TTY=$(tty) # For gpg to work properly with git
export LESS=-Ri       # Case insensitive less with color
export VISUAL="nvim"

##################################################
# Set XDG Base Directory Variables
##################################################
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_VIDEOS_DIR="$HOME/Videos"

##################################################
# Tool Specific Overrides
##################################################
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"
export npm_config_cache="$XDG_CACHE_HOME/npm"
export NUGET_PACKAGES="$XDG_CACHE_HOME/nuget"
export PULSE_COOKIE="$XDG_CONFIG_HOME/pulse/cookie"
export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
export TASKDATA="$XDG_DATA_HOME/task"
export TASKRC="$XDG_CONFIG_HOME/task/taskrc"
export ZSH="$XDG_DATA_HOME/oh-my-zsh"
export __GL_SHADER_DISK_CACHE_PATH="$XDG_CACHE_HOME/nv"
