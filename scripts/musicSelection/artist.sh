while [[ "$#" -gt 0 ]]; do
    case $1 in
        -g|--genre) genre="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [[ "$genre" == "" ]]; then
    artist=$(mpc list albumartist | shuf | rofi -i -dmenu -no-custom -p "Artist:")
else
    artist=$(mpc list albumartist genre "$genre" | shuf | rofi -i -dmenu -no-custom -p "Artist:")
fi
echo "Selected artist: $artist"
if [[ $artist == "" ]]; then # Aborted query
   exit 1
fi
path=$(dirname $(realpath $0))
$path/album.sh --artist "$artist" --genre "$genre"
