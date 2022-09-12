#!/bin/zsh
if [[ -z $SYSTEM_NAME ]]; then
    echo "Environment variable SYSTEM_NAME not set (this should be done by bootstrap or setSystemName.sh)"
    exit 1
fi
if [[ -z $HOME ]]; then
    echo "Environment variable HOME not set."
    exit 2
fi
if [[ -z $CONFIG ]]; then
    echo "Environment variable CONFIG not set."
    exit 3
fi

function make_symlink {
    target="$CONFIG/$1"
    name="$HOME/$2"
    mkdir -p $(dirname "$name")
    echo "$target\t\t -> $name"
    ln -s "$target" "$name"
}

# The good, following the XDG_CONFIG_DIR structure
make_symlink beets/config.yaml .config/beets/config.yaml
make_symlink bacon/prefs.toml .config/bacon/prefs.toml
make_symlink bat/config .config/bat/config
make_symlink git/gitignoreGlobal.conf .config/git/gitignoreGlobal.conf
make_symlink i3/i3.conf .config/i3/config
make_symlink i3/${SYSTEM_NAME}.conf .config/i3/system.conf
make_symlink i3/i3wsr/config.toml .config/i3wsr/config.toml
make_symlink i3/i3status.conf .config/i3status/config
make_symlink kitty/kitty.conf .config/kitty/kitty.conf
make_symlink mpd/${SYSTEM_NAME}.conf .config/mpd/mpd.conf
make_symlink mypy/mypy.ini .config/mypy/config
make_symlink nushell/config.nu .config/nushell/config.nu
make_symlink rofi/config.rasi .config/rofi/config.rasi
make_symlink taskwarrior/taskrc .config/taskwarrior/taskrc
make_symlink vim/init.vim .config/nvim/init.vim
make_symlink zathura/zathurarc .config/zathura/zathurarc
make_symlink mimetypes/mimeapps.list .config/mimeapps.list
make_symlink powersettings/xfce4-power-manager.xml .config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml
make_symlink emacs/emacs.service .config/systemd/user/default.target.wants/emacs.service

# The weird
make_symlink mimetypes/zathura.desktop .local/share/applications/zathura.desktop
make_symlink mimetypes/emacsclient.desktop .local/share/applications/emacsclient.desktop
make_symlink mimetypes/hdfview.desktop .local/share/applications/hdfview.desktop
make_symlink zsh/openPdf.sh .local/bin/pdf

# The EVIL, polluting my home directory
make_symlink alsa/asoundrc .asoundrc
make_symlink bash/bashrc.sh .bashrc
make_symlink bash/inputrc.sh .inputrc
make_symlink cargo/config.toml .cargo/config
make_symlink emacs/emacs.el .emacs.d/init.el
make_symlink git/gitconfig.conf .gitconfig
make_symlink gnuplot/gnuplot.conf .gnuplot # supports XDG starting at version 5.5 which is not on manjaro stable
make_symlink vim/init.vim .vimrc
make_symlink zsh/zshrc.sh .zshrc
