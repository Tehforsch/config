# If we start reaper before the interface is turned on
# it sets the connections up wrong
sudo cpupower frequency-set -g performance
while [ $(lsusb | grep BEHRINGER | wc -l) == 0 ]; do
    sleep 0.1
done
$CONFIG/audio/wireplumber_music_mode.sh
sleep 1
PIPEWIRE_LATENCY=“32/48000” pw-jack -p64 reaper
