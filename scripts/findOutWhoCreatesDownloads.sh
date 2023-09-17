while [[ 1 ]]; do
    if [[ -d ~/Downloads ]]; then
        notify-send "SOMEBODY CREATED DOWNLOADS FOLDER JO"
        ps -ef > ~/.playground/WHO_IS_AT_FAULT_$(date +%s)
        sleep 600
    fi
    sleep 5
done
