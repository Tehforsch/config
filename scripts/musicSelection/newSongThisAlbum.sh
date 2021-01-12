currentAlbumArtistTitle=$(mpc -f "%albumartist%\t%album%\t%title%" | head -n 1)
artist=$(printf "$currentAlbumArtistTitle" | cut -f 1)
album=$(printf "$currentAlbumArtistTitle" | cut -f 2)
title=$(printf "$currentAlbumArtistTitle" | cut -f 3)
songs=$(mpc find albumartist "$artist" album "$album")
echo $songs

numInPlaylist=$(mpc playlist -f "%title%" | grep -n "^$title\$" | cut -d ":" -f 1)
indexInPlaylist=$(( numInPlaylist - 1 ))
echo $indexInPlaylist
path=$(dirname $(realpath $0))
echo "$artist" "$album"
$path/songSelection.sh --preselect $indexInPlaylist "$artist" "$album"
