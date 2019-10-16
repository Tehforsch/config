if [[ $# -ne 1 ]]; then
    echo "Need one argument: The time at which to wake up."
else
    nowInSeconds=$(date +%s)
    thenInSeconds=$(date +%s -d $1)
    diffInSeconds=$((thenInSeconds - nowInSeconds))
    echo "Waking up in $diffInSeconds"
    # sudo rtcwake -u -s $diffInSeconds -m mem
fi
