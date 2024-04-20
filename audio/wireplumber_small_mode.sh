CONFIG=$HOME/projects/config
mkdir -p ~/.config/wireplumber/wireplumber.conf.d
cp $CONFIG/audio/wireplumber/51-alsa-disable-small-mode.conf ~/.config/wireplumber/wireplumber.conf.d/51-alsa-disable.conf
systemctl --user restart pipewire.service
