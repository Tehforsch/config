#!/bin/zsh

function make_symlink {
    target="$CONFIG/$1"
    name="$HOME/$2"
    mkdir -p $(dirname "$name")
    ln -s "$target" "$name"
}

make_symlink alsa/asoundrc .asoundrc
make_symlink bash/bashrc.sh .bashrc
make_symlink bash/inputrc.sh .inputrc
make_symlink beets/config.yaml .config/beets/config.yaml
make_symlink cargo/config.toml .cargo/config/config
make_symlink emacs/emacs.el .emacs.d/init.el
make_symlink git/gitignoreGlobal.conf .gitignoreGlobal
make_symlink git/gitconfig.conf .gitconfig
