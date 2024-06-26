if [ "$EUID" -eq 0 ]; then
    sudo systemctl stop firewalld
    sudo cpupower frequency-set -g performance
fi

# If we start reaper before the interface is turned on
# it sets the connections up wrong
if [ $1 == "music" ] || [ $1 == "amp" ] ; then
    pactl set-card-profile alsa_card.usb-BEHRINGER_UMC1820_F62F2AF7-00 pro-audio

    while [ $(lsusb | grep BEHRINGER | wc -l) == 0 ]; do
        sleep 0.1
    done
fi

HOME=/home/toni /home/toni/projects/config/audio/scripts/wireplumber_mode.sh $1
sleep 1
reaper
