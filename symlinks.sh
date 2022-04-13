#!/bin/zsh
if [[ -z $SYSTEM_NAME ]]; then
    echo "Environment variable SYSTEM_NAME not set (this should be done by bootstrap or setSystemName.sh)"
    exit 1
fi
function make_symlink {
    target="$CONFIG/$1"
    name="$HOME/$2"
    mkdir -p $(dirname "$name")
    echo "$target\t\t -> $name"
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
make_symlink mpd/${SYSTEM_NAME}.conf .config/mpd/mpd.conf
make_symlink mypy/mypy.ini .config/mypy/config
make_symlink nushell/config.nu .config/nushell/config.nu
make_symlink rofi/config.rasi .config/rofi/config.rasi
make_symlink taskwarrior/taskrc .config/taskwarrior/taskrc
make_symlink vim/init.vim .config/nvim/init.vim
make_symlink vim/init.vim .vimrc
make_symlink zathura/zathurarc.symlink .config/zathura/zathurarc
