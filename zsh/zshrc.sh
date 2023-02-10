source "$HOME/projects/config/zsh/paths.sh"
export fpath=($CONFIG/zsh/completions/ $fpath)
source "$CONFIG/zsh/setSystemName.sh"
source "$CONFIG/zsh/completionSettings.sh"
source "$CONFIG/zsh/readline.sh"
source "$CONFIG/zsh/history.sh"
source "$CONFIG/zsh/fzf.sh"
source "$CONFIG/zsh/prompt.sh"
source "$CONFIG/zsh/zshCdWidget.sh"
source "$CONFIG/zsh/launchWidget.sh"
source "$CONFIG/zsh/aliases.sh"
source "$CONFIG/zsh/dirStack.sh"

localConfig="$CONFIG/zsh/localConfig/${SYSTEM_NAME}.sh"
if [[ ! -a "$localConfig" ]]; then
    localConfig="$CONFIG/zsh/localConfig/default.sh"
fi
source "$localConfig"


ulimit -c unlimited

export PATH=$PATH:/opt/texlive/2021/bin/x86_64-linux

export PATH="$HOME/.poetry/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
