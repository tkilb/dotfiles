if [[ "$MACHINE" == "work-book" ]]; then
  plugins=(
    # aws-credentials
    # node
    # npm
  )
fi

export ZSH="${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh"

if [ ! -d "$ZSH" ]; then
  git clone https://github.com/ohmyzsh/ohmyzsh.git "$ZSH"
fi

if [ ! -d ${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-syntax-highlighting
fi

if [ ! -d ${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-autosuggestions
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
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${SHORT_HOST:-$HOST}-${ZSH_VERSION}"

source $ZSH/oh-my-zsh.sh
