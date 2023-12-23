cp $CONFIG/wireplumber/51-alsa-disable-music-mode.lua $HOME/.config/wireplumber/main.lua.d/51-alsa-disable.lua
systemctl --user restart pipewire.service
