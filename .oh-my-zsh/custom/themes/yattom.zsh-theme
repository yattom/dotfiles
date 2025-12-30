PROMPT="%U%F{green}%m%u%f%B%F{cyan} %U%~%f%u "'$(virtualenv_prompt_info)'"
%#%b "
PROMPT2="%_%% "
SPROMPT="%r is correct? [n,y,a,e]: "
RPROMPT='$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}git:(%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%} !%{$reset_color%}%{$fg[cyan]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}%{$fg[cyan]%})"
