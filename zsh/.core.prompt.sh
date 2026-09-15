# https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/robbyrussell.zsh-theme

local ret_status="%(?::%{$fg_bold[red]%}%{$fg[red]%}✗ )"
PROMPT='${ret_status}%{$fg_bold[cyan]%}%c%{$reset_color%}$(git_prompt_info) '

ZSH_THEME="robbyrussell"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%} %{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
