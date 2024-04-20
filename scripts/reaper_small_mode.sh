if [ "$EUID" -eq 0 ]; then
    sudo systemctl stop firewalld
    sudo cpupower frequency-set -g performance
fi

HOME=/home/toni /home/toni/projects/config/audio/wireplumber_small_mode.sh
sleep 1
reaper
