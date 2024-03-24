# If we start reaper before the interface is turned on
# it sets the connections up wrong
sudo cpupower frequency-set -g performance
pactl set-card-profile alsa_card.usb-BEHRINGER_UMC1820_F62F2AF7-00 pro-audio
while [ $(lsusb | grep BEHRINGER | wc -l) == 0 ]; do
    sleep 0.1
done
$CONFIG/audio/wireplumber_small_mode.sh
sleep 1
reaper
