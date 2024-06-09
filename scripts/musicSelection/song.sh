while [[ "$#" -gt 0 ]]; do
    case $1 in
        -g|--genre) genre="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

separator="\t"
formatString="%albumartist%$separator%album%$separator%title%"
list=$(mpc -f "$formatString" search genre "$genre")
outputSeparator=" "
shuffled=$(echo -E "$list" | uniq | shuf)
index=$(echo -E "$shuffled" | column -o "$outputSeparator" -s "$(printf "\t")" -t -T 1,2,3 --output-width 200  | rofi -i -dmenu -no-custom -format "d" -kb-custom-1 "Ctrl+Return" -p "Song:" -width 1920)
exitCode=$?
artistAlbumTitle=$(echo -E "$shuffled" | head -n $index | tail -n 1)
artist=$(echo -E "$artistAlbumTitle" | cut -f 1)
album=$(echo -E "$artistAlbumTitle" | cut -f 2)
title=$(echo -E "$artistAlbumTitle" | cut -f 3)
path=$(dirname $(realpath $0))

if [ "$exitCode" == "10" ]; then
    queue="--queue"
fi

$path/playSong.sh $queue "$artist" "$album" "$title"
