source "$HOME/projects/config/zsh/zshenv"
source "$HOME/projects/config/zsh/paths.sh"
source "$CONFIG/zsh/completionSettings.sh"
source "$CONFIG/zsh/readline.sh"
source "$CONFIG/zsh/history.sh"
source "$CONFIG/zsh/fzf/fzf.sh"
source "$CONFIG/zsh/prompt.sh"
source "$CONFIG/zsh/zshCdWidget.sh"
source "$CONFIG/zsh/launchWidget.sh"
source "$CONFIG/zsh/aliases.sh"
source "$CONFIG/zsh/dirStack.sh"
source "$CONFIG/taskwarrior/aliases"

localConfig="$CONFIG/zsh/localConfig/$(hostname).sh"
if [[ ! -a "$localConfig" ]]; then
    localConfig="$CONFIG/zsh/localConfig/default.sh"
fi
source "$localConfig"


ulimit -c unlimited

export PATH=$PATH:/opt/texlive/2021/bin/x86_64-linux

export PATH="$HOME/.poetry/bin:$PATH"
export PATH=$PATH:/usr/lib/llvm15/bin/
