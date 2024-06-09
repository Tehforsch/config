if [ "$1" == "--queue" ]; then
    queue=1
    shift
else
    queue=0
fi
if [[ $# -ne 3 ]]; then
    exit 1
fi
path=$(dirname $(realpath $0))
formatString="%track% - %title%"
artist=$1
album=$2
title=$3
if [[ $artist == "" ]]; then # Aborted query
   exit 1
fi
if [[ $album == "" ]]; then # Aborted query
   exit 1
fi
if [[ $title == "" ]]; then # Aborted query
   exit 1
fi
echo "Playing:"
echo "$artist"
echo "$album"
echo "$title"

if [[ $queue -eq 0 ]]; then
    mpc clear
    mpc findadd album "$album" albumartist "$artist"
    numInPlaylist=$(mpc playlist -f "%title%" | grep -n "^$title\$" | cut -d ":" -f 1)
    echo $numInPlaylist
    mpc play $numInPlaylist
else
    mpc findadd album "$album" albumartist "$artist" title "$title"
fi
