##################################################
# Load Profile and Key Variables
##################################################
source $HOME/.profile
_ZSH_DOT_FILE_DIR=$HOME/.dotfiles/zsh/
# MACHINE (should be set in .profile):
#   linux-book | linux-box | steam-deck | work-book
[ -z "$MACHINE" ] && echo "WARNING: MACHINE is not set!"

##################################################
# Environment Variables
##################################################
if [ "$MACHINE" = "steam-deck" ]; then
  export NVIM_PLUGIN_DISABLED_LSP_CONFIG="true"
  export NVIM_PLUGIN_DISABLED_NONE_LS="true"
  export NVIM_PLUGIN_DISABLED_TREESITTER="true"
  export NVIM_PLUGIN_DISABLED_TYPESCRIPT_TOOLS="true"
fi

##################################################
# Source Paths
##################################################
machineList=("shared" "$MACHINE")
moduleList=("core" "config" "feature" "aliases" "routine" "prompt")

# Path settings
for machine in ${machineList}; do
  if [ -f $_ZSH_DOT_FILE_DIR/.paths.$machine.sh ]; then
    source $_ZSH_DOT_FILE_DIR/.paths.$machine.sh
  fi
done

# loop through and source modules with .feature. prefix
source $_ZSH_DOT_FILE_DIR/.core.path.sh
source $_ZSH_DOT_FILE_DIR/.core.settings.sh
source $_ZSH_DOT_FILE_DIR/.core.install.sh
source $_ZSH_DOT_FILE_DIR/.core.zsh.sh
source $_ZSH_DOT_FILE_DIR/.core.prompt.sh

for f in $_ZSH_DOT_FILE_DIR/.*; do
  if [[ $f =~ \.feature\..*\.sh$ ]]; then
    source $f
  fi
done

if [ "$MACHINE" = "work-book" ]; then
  [ -f ~/.config/dotfiles-work/zsh/.feature.work.sh ] && source ~/.config/dotfiles-work/zsh/.feature.work.sh
fi
