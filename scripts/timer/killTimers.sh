for timerId in $(pgrep -f timer/timer); do
    kill $timerId
done
