#!/bin/zsh
if [[ -z $HOME ]]; then
    echo "Environment variable HOME not set."
    exit 2
fi
if [[ $# == 1 ]]; then
    SYSTEM_NAME=$1
else
    SYSTEM_NAME=$(hostname)
fi
echo "Setting symlinks for $SYSTEM_NAME"

CONFIG=$HOME/projects/config

function make_symlink {
    target="$CONFIG/$1"
    name="$HOME/$2"
    mkdir -p $(dirname "$name")
    if [[ -L "$name" ]]; then
        if [[ $(readlink -f "$name") != $target ]]; then
            echo "Deleting previously existing symlink: $target"
            rm $name
            ln -s "$target" "$name"
        fi
    elif [[ ! -a "$name" ]]; then
        echo "$target\t\t -> $name"
        ln -s "$target" "$name"
    else
        echo "File already exists: $name"
    fi
}

# The good, following the XDG_CONFIG_DIR structure
make_symlink xdg/user-dirs.dirs .config/user-dirs.dirs
make_symlink beets/config.yaml .config/beets/config.yaml
make_symlink bat/config .config/bat/config
make_symlink dunst/dunstrc .config/dunst/dunstrc
make_symlink i3/i3.conf .config/i3/config
make_symlink i3/${SYSTEM_NAME}.conf .config/i3/system.conf
make_symlink i3/i3wsr/config.toml .config/i3wsr/config.toml
make_symlink i3/i3status_${SYSTEM_NAME}.conf .config/i3status/config
make_symlink keepassxc/keepassxc.ini .config/keepassxc/keepassxc.ini
make_symlink kitty/kitty.conf .config/kitty/kitty.conf
make_symlink kitty/${SYSTEM_NAME}.conf .config/kitty/system.conf
make_symlink mpd/${SYSTEM_NAME}.conf .config/mpd/mpd.conf
make_symlink rofi/config.rasi .config/rofi/config.rasi
make_symlink vim/init.vim .config/nvim/init.vim
make_symlink nvim .config/nvim
make_symlink zathura/zathurarc .config/zathura/zathurarc
make_symlink zsh/zshrc.sh .config/zsh/.zshrc # ZDOTDIR
make_symlink zsh/zshenv .zshenv
make_symlink bash/inputrc.sh .config/readline/inputrc # INPUTRC
make_symlink git/gitconfig.conf .config/git/config
make_symlink vim/init.vim .config/vim/vimrc
make_symlink cargo/${SYSTEM_NAME}.toml .cargo/config.toml # ...
make_symlink flameshot/flameshot.ini .config/flameshot/flameshot.ini
make_symlink helix/config.toml .config/helix/config.toml
make_symlink nushell/config.nu .config/nushell/config.nu
make_symlink nushell/env.nu .config/nushell/env.nu
make_symlink vdirsyncer/config .config/vdirsyncer/config
make_symlink khal/config .config/khal/config
make_symlink striputary/config.yml .config/striputary/config.yaml
make_symlink qbittorrent/qBittorrent.conf .config/qBittorrent/qBittorrent.conf
make_symlink bottom/bottom.toml .config/bottom/bottom.toml
make_symlink torga/torga.yml .config/todo/torga.yml
make_symlink rmpc/config.ron .config/rmpc/config.ron
make_symlink rmpc/theme.ron .config/rmpc/themes/default.ron
make_symlink mbsync/mbsyncrc .config/isyncrc
make_symlink notmuch/config .notmuch-config
make_symlink meli/config.toml .config/meli/config.toml
make_symlink aerc/aerc.conf .config/aerc/aerc.conf
make_symlink aerc/accounts.conf .config/aerc/accounts.conf
make_symlink aerc/binds.conf .config/aerc/binds.conf
make_symlink aerc/strato-query-map .config/aerc/strato-query-map
make_symlink aerc/gmail-query-map .config/aerc/gmail-query-map
make_symlink jj/config.toml .config/jj/config.toml

# The EVIL, polluting my home directory
make_symlink bash/bashrc.sh .bashrc
make_symlink ssh/config .ssh/config
make_symlink claude/settings.json .claude/settings.json
make_symlink claude/CLAUDE.md .claude/CLAUDE.md
make_symlink xkb/symbols/custom .config/xkb/symbols/custom
