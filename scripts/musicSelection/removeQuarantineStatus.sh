artistAlbums=$(mpc find -f "%artist%\t%album%" genre quarantine | uniq)
artistAlbumIndex=$(echo -E "$artistAlbums" | column -o "$outputSeparator" -s "$(printf "\t")" -t | rofi -i -dmenu -no-custom -format "d" -p "Album:")
artistAlbum=$(echo -E "$artistAlbums" | head -n $artistAlbumIndex | tail -n 1)
artist=$(echo -E "$artistAlbum" | cut -f 1)
album=$(echo -E "$artistAlbum" | cut -f 2)
beet modify -ya albumartist:"$artist" album:"$album" genre=""
