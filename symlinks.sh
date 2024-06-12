#!/bin/zsh
if [[ -z $HOME ]]; then
    echo "Environment variable HOME not set."
    exit 2
fi
SYSTEM_NAME=$(hostname)
CONFIG=$HOME/projects/config

function make_symlink {
    target="$CONFIG/$1"
    name="$HOME/$2"
    mkdir -p $(dirname "$name")
    if [[ ! -a "$name" ]]; then
        echo "$target\t\t -> $name"
        ln -s "$target" "$name"
    fi
}

# The good, following the XDG_CONFIG_DIR structure
make_symlink beets/config.yaml .config/beets/config.yaml
make_symlink bat/config .config/bat/config
make_symlink i3/i3.conf .config/i3/config
make_symlink i3/${SYSTEM_NAME}.conf .config/i3/system.conf
make_symlink i3/i3wsr/config.toml .config/i3wsr/config.toml
make_symlink i3/i3status.conf .config/i3status/config
make_symlink hyprland/hyprland.conf .config/hypr/hyprland.conf
make_symlink hyprland/waybar.jsonc .config/waybar/config.jsonc
make_symlink hyprland/waybar-style.css .config/waybar/style.css
make_symlink hyprland/hyprland-autoname-workspaces-config.toml .config/hyprland-autoname-workspaces/config.toml
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
make_symlink audio/jack-reaper.conf .config/pipewire/jack.conf.d/10-reaper.conf
make_symlink wireplumber/51-alsa-disable-music-mode.lua .config/wireplumber/main.lua.d/51-alsa-disable.lua
make_symlink flameshot/flameshot.ini .config/flameshot/flameshot.ini

# The weird
make_symlink taskwarrior/${SYSTEM_NAME}.conf .config/task/system.conf

# The EVIL, polluting my home directory
make_symlink bash/bashrc.sh .bashrc
make_symlink emacs/init.el .emacs.d/init.el
make_symlink ssh/config .ssh/config
