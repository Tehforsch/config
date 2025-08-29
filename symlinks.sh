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
make_symlink beets/config.yaml .config/beets/config.yaml
make_symlink bat/config .config/bat/config
make_symlink dunst/dunstrc .config/dunst/dunstrc
make_symlink sway/i3wsr/config.toml .config/i3wsr/config.toml
make_symlink sway/i3status_${SYSTEM_NAME}.toml .config/i3status-rust/config.toml
make_symlink sway/config .config/sway/config
make_symlink sway/system_${SYSTEM_NAME}.conf .config/sway/system.conf
make_symlink keepassxc/keepassxc.ini .config/keepassxc/keepassxc.ini
make_symlink kitty/kitty.conf .config/kitty/kitty.conf
make_symlink mpd/${SYSTEM_NAME}.conf .config/mpd/mpd.conf
make_symlink rofi/config.rasi .config/rofi/config.rasi
make_symlink vim/init.vim .config/nvim/init.vim
make_symlink zathura/zathurarc .config/zathura/zathurarc
make_symlink taskwarrior/taskrc .config/task/taskrc
make_symlink taskwarrior/hooks .local/share/task/hooks
make_symlink zsh/zshrc.sh .config/zsh/.zshrc # ZDOTDIR
make_symlink zsh/zshenv .zshenv
make_symlink bash/inputrc.sh .config/readline/inputrc # INPUTRC
make_symlink newsboat/config .config/newsboat/config
make_symlink newsboat/urls .config/newsboat/urls
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
make_symlink mako/config .config/mako/config
make_symlink bottom/bottom.toml .config/bottom/bottom.toml

# The weird
make_symlink taskwarrior/${SYSTEM_NAME}.conf .config/task/system.conf

# The EVIL, polluting my home directory
make_symlink bash/bashrc.sh .bashrc
make_symlink emacs/init.el .emacs.d/init.el
make_symlink ssh/config .ssh/config
make_symlink claude/settings.json .claude/settings.json
make_symlink claude/CLAUDE.md .claude/CLAUDE.md
make_symlink xkb/symbols/custom .config/xkb/symbols/custom
