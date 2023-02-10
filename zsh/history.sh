mkdir -p $(dirname "$HISTFILE")
export HISTFILE="$XDG_STATE_HOME"/zsh/history

export HISTFILESIZE=1000000
export HISTSIZE=1000000
export SAVEHIST=1000000

# Remove duplicates
setopt HIST_IGNORE_ALL_DUPS
setopt inc_append_history
