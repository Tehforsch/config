# sudo systemctl stop firewalld
# sudo cpupower frequency-set -g performance

# If we start reaper before the interface is turned on
# it sets the connections up wrong
if [ "$1" == "music" ] || [ "$1" == "amp" ] ; then
    echo "hi"
    while [ $(lsusb | grep BEHRINGER | wc -l) == 0 ]; do
        sleep 0.1
    done

    pactl set-card-profile alsa_card.usb-BEHRINGER_UMC1820_F62F2AF7-00 pro-audio
fi

HOME=/home/toni /home/toni/projects/config/audio/scripts/wireplumber_mode.sh $1
sleep 0.3
# 64 is also possible but why take the risk when I cant hear this part of the latency anyways
PIPEWIRE_QUANTUM=128/48000 reaper &

sleep 5


qpwgraph -a -x /home/toni/projects/config/audio/wireplumber/reaper.qpwgraph
