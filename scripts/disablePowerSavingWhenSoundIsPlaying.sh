while true; do
    soundPlaying=$(pacmd list-sink-inputs | grep -c 'state: RUNNING') 
    if [[ $soundPlaying == 1 ]]; then
        xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/presentation-mode -s true
    else
        xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/presentation-mode -s false
    fi
    sleep 60
done
