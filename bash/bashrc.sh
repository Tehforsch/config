PATH=$PATH:$HOME/gpfs/bwfor/home/hd/hd_hd/hd_hp240/projects/gitAnnex/git-annex.linux
export CONFIG=$HOME/projects/config
# Load aliases
source "$CONFIG/zsh/localConfigs/bw.sh"
source "$CONFIG/zsh/aliases.sh"
# Load nice solarized dircolors
eval $(dircolors "$CONFIG/bash/dirColors.sh")

PS1="\n\[\033[01;33;40m\]\u\[\033[01;36;40m\]@\h \[\033[01;35;40m\]\w\[\e[0m\]\n\[\033[01;34;40m\] %\[\e[0m\] "

#Avoid duplicates in history
export HISTCONTROL=ignoredups:erasedups  
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file and reread it
export PROMPT_COMMAND="history -n; history -w; history -c; history -r;history -a; $PROMPT_COMMAND"

# Hopefully map Ctrl-w to remove only until last slash or so (like in zsh)
stty werase undef
bind '\C-w:unix-filename-rubout'
export TERM='xterm-256color'
source ~/modules.sh

export HDF5_DISABLE_VERSION_CHECK=2
