album=$(mpc list album | shuf | head -n 1)
mpc clear
mpc findadd album "$album"
mpc play

path=$(dirname $(realpath $0))
$path/showNotification.sh
