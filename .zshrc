# Path to your oh-my-zsh configuration.
ZSH=~/.usrconfig/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="blinks"

# Aliases
source ~/.usrconfig/.aliases

# Automatically ls after cd (even when not using cd but just typing the directory)
function chpwd() {
    emulate -L zsh
    l --color=auto
}

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Disable auto correction
unsetopt correctall

# Enable auto completion for special directories like . and ..
zstyle ':completion:*' special-dirs true

# Uncomment to change how often before auto-updates occur? (in days)
export UPDATE_ZSH_DAYS=40

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git autojump)

source $ZSH/oh-my-zsh.sh

# User configuration
#export PATH="/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/cuda-5.5/bin"
PATH=/home/toni/.usrconfig/bin:/home/toni/.bin:$PATH

