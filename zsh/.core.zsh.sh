if [[ "$MACHINE" == "work-book" ]]; then
  plugins=(
    # aws-credentials
    # node
    # npm
  )
fi

# if [[ "$OS" == "mac" ]]; then
#     plugins=(
#         "${plugins[@]}"
#     )
# fi

if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

plugins=(
  "${plugins[@]}"
  colored-man-pages
  copypath
  encode64
  git
  history
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Oh My Zsh
export ZSH_DISABLE_COMPFIX=true

source $HOME/.oh-my-zsh/oh-my-zsh.sh
