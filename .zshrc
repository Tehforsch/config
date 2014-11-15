# Path to your oh-my-zsh configuration.
ZSH=~/.usrconfig/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="blinks"

# Auto ls when cding
function chpwd() {
    emulate -L zsh
    ls -alF
}

# Aliases
source ~/.usrconfig/.aliases

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Disable auto correction
unsetopt correct_all
unsetopt correct
setopt nocorrectall

# Enable auto completion for special directories like . and ..
zstyle ':completion:*' special-dirs true

# Uncomment to change how often before auto-updates occur? (in days)
export UPDATE_ZSH_DAYS=40

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git autojump)

source $ZSH/oh-my-zsh.sh

# User configuration
PATH=/home/toni/.cabal/bin:/home/toni/.usrconfig/bin:/home/toni/.bin:$PATH
PYTHONDONTWRITEBYTECODE="1"
