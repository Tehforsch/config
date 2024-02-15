cp $CONFIG/wireplumber/51-alsa-disable-default-mode.lua ~/.config/wireplumber/main.lua.d/51-alsa-disable.lua
systemctl --user restart pipewire.service
