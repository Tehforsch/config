sleep 4
for i in $(seq 1 $1); do
    xdotool click 3
    sleep 0.1
    xdotool key t
    sleep 0.1
    xdotool mousemove_relative 0 25
    sleep 0.1
done
