# Setup fzf
# ---------
if [[ ! "$PATH" == */home/toni/.local/share/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/toni/.local/share/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/toni/.local/share/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/toni/.local/share/fzf/shell/key-bindings.zsh"
