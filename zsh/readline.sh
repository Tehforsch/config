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

# Delete path segment backward
backward-kill-dir() {
    local WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
    zle backward-kill-word
    zle -f kill
}

zle -N backward-kill-dir
bindkey '^u' backward-kill-dir

bindkey '^l' insert-last-word

# Make zsh autocomplete even when the cursor is directly in front of a string
bindkey '^i' expand-or-complete-prefix

export EDITOR="vim"
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Make delete key delete in vim mode
bindkey -a '^[[3~' delete-char
