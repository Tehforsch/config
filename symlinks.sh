#!/bin/zsh
function make_symlink {
    target="$CONFIG/$1"
    name="$HOME/$2"
    mkdir -p $(dirname "$name")
    echo "$target"
    echo "$name"
    ln -fs "$target" "$name"
}

make_symlink alsa/asoundrc .asoundrc
make_symlink bash/bashrc.sh .bashrc
make_symlink bash/inputrc.sh .inputrc
make_symlink beets/config.yaml .config/beets/config.yaml
make_symlink cargo/config.toml .cargo/config
make_symlink emacs/emacs.el .emacs.d/init.el
make_symlink git/gitignoreGlobal.conf .gitignoreGlobal
make_symlink git/gitconfig.conf .gitconfig
make_symlink gnuplot/gnuplot.conf .gnuplot # supports XDG starting at version 5.5 which is not on manjaro stable
make_symlink i3/i3.conf .config/i3/config
make_symlink i3/i3status.conf .config/i3status/config
make_symlink kitty/kitty.conf .config/kitty/kitty.conf
make_symlink mpd/${systemName}.conf .config/mpd/mpd.conf
