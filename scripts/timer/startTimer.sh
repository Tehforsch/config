minutes=$(rofi -dmenu)
seconds=$(( $minutes * 60 ))
path=$(dirname $(realpath $0))
"$path/timer.sh" $seconds

