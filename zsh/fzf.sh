# Fzf settings
source ~/.fzf.zsh
# Use fd for fzf
export FZF_DEFAULT_COMMAND="fd --follow"
export FZF_CTRL_T_COMMAND="fd --follow -I"

source $CONFIG/fzf/widgets.zsh
