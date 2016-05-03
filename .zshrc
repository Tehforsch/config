# Path to your oh-my-zsh configuration.
CONFIG=/home/toni/projects/config
ZSH=$CONFIG/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="blinks"

# Aliases
source $CONFIG/aliases

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Enable auto completion for special directories like . and ..
zstyle ':completion:*' special-dirs true

# Uncomment to change how often before auto-updates occur? (in days)
export UPDATE_ZSH_DAYS=40

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git fasd)

source $ZSH/oh-my-zsh.sh

# User configuration
PATH=/home/toni/.cabal/bin:$CONFIG/bin:/home/toni/.bin:$PATH
PYTHONDONTWRITEBYTECODE="1"

# Binding 
bindkey -s '^f' 'bg && disown && exit\n'

# Implement the fasd keybind to jump into a dir with j.
alias j='fasd_cd -d'
# fasd - vim
alias v='f -e vim'
# fasd - okular 
alias o='f -e okular'

# bind C-g to append &! to the written command (which nohups it), \n to run the command, ^z to suspend and exit\n to close the current terminal
bindkey -s '^g' '&!\n^z exit\n'
bindkey ^l forward-word
bindkey ^h backward-word

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
