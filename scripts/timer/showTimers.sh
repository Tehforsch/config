for timerId in $(pgrep -f timer/timer.sh); do
    runningTime=$(ps -o etimes= $timerId)
    max=$(ps o cmd $timerId | tail -n 1 | awk '{print $3}')
    if [ "$runningTime" -gt "$max" ]; then
        runningTime=$max
    fi
    echo -n "$runningTime/$max "
done
for timerId in $(pgrep -f timer/timerAt.sh); do
    runningTime=$(ps -o etimes= $timerId)
    max=$(ps o cmd $timerId | tail -n 1 | awk '{print $3}')
    echo -n "$(date +%H:%M)/$max "
done
echo ""
