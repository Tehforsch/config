autoload -U compinit; compinit

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end

zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# Enable auto completion for special directories like . and ..
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' menu select

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Disable "do you wish to see all ... possibilities?" prompt
LISTMAX=0

# Make tab completion be more like ls -la
zstyle ':completion:*' file-list all
