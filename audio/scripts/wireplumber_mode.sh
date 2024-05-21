CONFIG=$HOME/projects/config

mkdir -p $HOME/.config/wireplumber/wireplumber.conf.d

cp $CONFIG/audio/wireplumber/51-alsa-disable-$1-mode.conf $HOME/.config/wireplumber/wireplumber.conf.d/51-alsa-disable.conf
systemctl --user restart pipewire.service
