# Path to your oh-my-zsh configuration.
ZSH=~/.usrconfig/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="blinks"

# # Auto ls when cding
# function chpwd() {
#     emulate -L zsh
#     ls -alF
# }

# Aliases
source ~/.usrconfig/.aliases

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
PATH=/home/toni/.cabal/bin:/home/toni/.usrconfig/bin:/home/toni/.bin:$PATH
PYTHONDONTWRITEBYTECODE="1"

# Binding 
bindkey -s '^d' 'bg && disown && exit\n'

# Implement the fasd keybind to jump into a dir with j.
alias j='fasd_cd -d'
# fasd - vim
alias v='f -e vim'
# fasd - okular 
alias o='f -e okular'
