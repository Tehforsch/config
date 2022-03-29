export HISTFILE=~/.zsh_history
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export SAVEHIST=1000000

# Remove duplicates
setopt HIST_IGNORE_ALL_DUPS
# Allow sharing of history
setopt share_history
setopt inc_append_history
