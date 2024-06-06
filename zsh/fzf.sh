# Use fd for fzf
export FZF_DEFAULT_COMMAND="fd --follow"
export FZF_CTRL_T_COMMAND="fd --follow -I"

source $CONFIG/zsh/fzf_widgets.sh

bindkey '^r' fzf-history-widget
bindkey '^f' fzf-cd-home-widget
bindkey '^v' fzf-cd-widget
bindkey '^T' fzf-file-widget

source $CONFIG/zsh/forgit/forgit.plugin.zsh
