# If we start reaper before the interface is turned on
# it sets the connections up wrong
if [ "$EUID" -eq 0 ]; then
    sudo systemctl stop firewalld
    sudo cpupower frequency-set -g performance
fi

pactl set-card-profile alsa_card.usb-BEHRINGER_UMC1820_F62F2AF7-00 pro-audio
while [ $(lsusb | grep BEHRINGER | wc -l) == 0 ]; do
    sleep 0.1
done
HOME=/home/toni /home/toni/projects/config/audio/wireplumber_music_mode.sh
sleep 1
reaper
