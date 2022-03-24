# Reduce timeout after going to normal mode
export KEYTIMEOUT=1

# This will make ctrl-w delete only part of a path, not entire paths
WORDCHARS=''

# Vim mode
bindkey -v
export KEYTIMEOUT=1

bindkey '^P' up-history
bindkey '^N' down-history

# backspace and ^h working even after
# returning from command mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char

# ctrl-w removed word backwards
bindkey '^w' backward-kill-word

# Push current command to stack and pop it after another command has been entered
bindkey '^q' push-line

# Binding to close the terminal with a process running in it without killing the process
bindkey -s '^u' 'bg && disown && kitty @ close-window\n'

bindkey '^l' insert-last-word

export EDITOR="vim"
bindkey '^e' edit-command-line

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
