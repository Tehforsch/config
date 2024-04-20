mkdir -p $HOME/.config/wireplumber/wireplumber.conf.d
cp $HOME/projects/config/audio/wireplumber/51-alsa-disable-music-mode.conf $HOME/.config/wireplumber/wireplumber.conf.d/51-alsa-disable.conf
systemctl --user restart pipewire.service
