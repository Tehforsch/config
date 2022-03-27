export HISTFILE=~/.zsh_history
export HISTFILESIZE=10000000
export HISTSIZE=10000000

# Remove duplicates
setopt HIST_IGNORE_ALL_DUPS
# Allow sharing of history
setopt append_history
setopt share_history
setopt inc_append_history
