cp $CONFIG/wireplumber/51-alsa-disable-only-small-mode.lua ~/.config/wireplumber/main.lua.d/51-alsa-disable.lua
systemctl --user restart pipewire.service
