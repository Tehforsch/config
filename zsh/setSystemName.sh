# This sets some paths such as where the CONFIG folder lies. Makes it easier to use on other machines without getting confused
systemName=$(cat $HOME/.systemName)
if [[ -a "$HOME/.localConfig" ]]; then
    source "$HOME/.localConfig"
fi
