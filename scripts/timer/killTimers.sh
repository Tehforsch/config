for timerId in $(pgrep -f timer/timer); do
    kill $timerId
done

for timerId in $(pgrep -f timer/repeat); do
    kill $timerId
done
