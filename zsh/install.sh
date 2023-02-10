sudo ln -s $(realpath $CONFIG/zsh/zshenv) /etc/zsh/zshenv

if [[ $SHELL != "/usr/bin/zsh" ]]; then
    chsh -s /bin/zsh
fi
