# sudo systemctl stop firewalld
# sudo cpupower frequency-set -g performance

# If we start reaper before the interface is turned on
# it sets the connections up wrong
if [ "$1" == "music" ] || [ "$1" == "amp" ] ; then
    while [ $(lsusb | grep BEHRINGER | wc -l) == 0 ]; do
        sleep 0.1
    done

    pactl set-card-profile alsa_card.usb-BEHRINGER_UMC1820_F62F2AF7-00 pro-audio
fi

# HOME=/home/toni /home/toni/projects/config/audio/scripts/wireplumber_mode.sh $1
sleep 0.3
qpwgraph -a -x /home/toni/projects/config/audio/wireplumber/reaper.qpwgraph
PIPEWIRE_QUANTUM=64/48000 reaper

