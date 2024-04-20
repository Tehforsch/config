HOME=/home/toni
CONFIG=/home/toni/projects/config
mkdir -p $HOME/.config/wireplumber/wireplumber.conf.d
cp $CONFIG/audio/wireplumber/51-alsa-disable-default-mode.conf $HOME/.config/wireplumber/wireplumber.conf.d/51-alsa-disable.conf
systemctl --user restart pipewire.service
