currentAlbumArtist=$(mpc -f "%artist%\t%album%" | head -n 1)
echo $currentAlbumArtist
artist=$(printf "$currentAlbumArtist" | cut -f 1)
album=$(printf "$currentAlbumArtist" | cut -f 2)
songs=$(mpc find artist "$artist" album "$album")
path=$(dirname $(realpath $0))
trackNum=

discNumber=$(mpc list disc album "$album" title "$title")
trackNumber=$(mpc list track album "$album" title "$title")
$path/songSelection.sh "$artist" "$album"
