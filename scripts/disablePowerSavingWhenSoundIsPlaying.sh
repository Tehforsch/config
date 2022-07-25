while true; do
    soundPlaying=$(pacmd list-sink-inputs | grep -c "RUNNING") 
    if [[ $soundPlaying -ge 1 ]]; then
        xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/presentation-mode -s true
    else
        xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/presentation-mode -s false
    fi
    sleep 60
done
