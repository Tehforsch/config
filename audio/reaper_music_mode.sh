sudo cpupower frequency-set -g performance
$CONFIG/audio/wireplumber_music_mode.sh
sleep 1
PIPEWIRE_LATENCY=“32/48000” pw-jack -p64 reaper
