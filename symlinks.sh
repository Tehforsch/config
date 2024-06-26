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
    if [[ ! -a "$name" ]]; then
        echo "$target\t\t -> $name"
        ln -s "$target" "$name"
    fi
}

# The good, following the XDG_CONFIG_DIR structure
make_symlink beets/config.yaml .config/beets/config.yaml
make_symlink bacon/prefs.toml .config/bacon/prefs.toml
make_symlink bat/config .config/bat/config
make_symlink i3/i3.conf .config/i3/config
make_symlink i3/${SYSTEM_NAME}.conf .config/i3/system.conf
make_symlink i3/i3wsr/config.toml .config/i3wsr/config.toml
make_symlink i3/i3status.conf .config/i3status/config
make_symlink kitty/kitty.conf .config/kitty/kitty.conf
make_symlink mpd/${SYSTEM_NAME}.conf .config/mpd/mpd.conf
make_symlink mypy/mypy.ini .config/mypy/config
make_symlink nushell/config.nu .config/nushell/config.nu
make_symlink rofi/config.rasi .config/rofi/config.rasi
make_symlink vim/init.vim .config/nvim/init.vim
make_symlink zathura/zathurarc .config/zathura/zathurarc
make_symlink mimetypes/mimeapps.list .config/mimeapps.list
make_symlink powersettings/${SYSTEM_NAME}.xml .config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml
make_symlink emacs/emacs.service .config/systemd/user/default.target.wants/emacs.service
make_symlink taskwarrior/taskrc .config/task/taskrc
make_symlink taskwarrior/hooks .local/share/task/hooks
make_symlink xmonad/xmonad.hs .config/xmonad/xmonad.hs
make_symlink xmonad/lib/XMobarConfig.hs .config/xmonad/lib/XMobarConfig.hs
make_symlink xmonad/lib/Colors.hs .config/xmonad/lib/Colors.hs
make_symlink xmonad/xmobarrc .config/xmonad/xmobarrc
make_symlink zsh/zshrc.sh .config/zsh/.zshrc # ZDOTDIR
make_symlink bash/inputrc.sh .config/readline/inputrc # INPUTRC
make_symlink newsboat/config .config/newsboat/config
make_symlink newsboat/urls .config/newsboat/urls
make_symlink git/gitconfig.conf .config/git/config
make_symlink alsa/asoundrc .config/alsa/asoundrc
make_symlink vim/init.vim .config/vim/vimrc
make_symlink cargo/${SYSTEM_NAME}.toml .cargo/config.toml # ...
make_symlink leftwm/config.ron .config/leftwm/config.ron
make_symlink leftwm/lefthk.ron .config/lefthk/config.ron
# make_symlink leftwm/startup_script.desktop .config/autostart/startup_script.desktop
# make_symlink sxhkd/sxhkdrc .config/sxhkd/sxhkdrc
make_symlink audio/jack-reaper.conf .config/pipewire/jack.conf.d/10-reaper.conf
make_symlink journal/journal.service .config/systemd/user/default.target.wants/journal.service
make_symlink journal/journal.service .config/systemd/user/journal.service

# The weird
make_symlink mimetypes/zathura.desktop .local/share/applications/zathura.desktop
make_symlink mimetypes/emacsclient.desktop .local/share/applications/emacsclient.desktop
make_symlink mimetypes/hdfview.desktop .local/share/applications/hdfview.desktop
make_symlink zsh/openPdf.sh .local/bin/pdf
make_symlink taskwarrior/${SYSTEM_NAME}.conf .config/task/system.conf

# The EVIL, polluting my home directory
make_symlink bash/bashrc.sh .bashrc
make_symlink emacs/init.el .emacs.d/init.el
make_symlink gnuplot/gnuplot.conf .gnuplot # supports XDG starting at version 5.5 which is not on manjaro stable
make_symlink ssh/config .ssh/config
