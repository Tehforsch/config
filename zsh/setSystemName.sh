export SYSTEM_NAME=$(cat ~/.config/systemName/name)
if [[ -a "$HOME/.localConfig" ]]; then
    source "$HOME/.localConfig"
fi
