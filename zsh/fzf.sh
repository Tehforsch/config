# Fzf settings
source ~/.fzf.zsh
# Use fd for fzf
export FZF_DEFAULT_COMMAND="fd --follow"
export FZF_CTRL_T_COMMAND="fd --follow -I"

source $CONFIG/fzf/widgets.zsh

bindkey '^r' fzf-history-widget
bindkey '^f' fzf-cd-home-widget
bindkey '^v' fzf-cd-widget
bindkey '^T' fzf-file-widget
