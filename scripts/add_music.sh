#!/usr/bin/env bash
set -eu

musicFolder=~/music
tmpDir=

cleanup() {
    if [[ -n "$tmpDir" ]]; then
        rm -rf "$tmpDir"
    fi
}
trap cleanup EXIT

if [[ $# != 1 ]]; then
    echo "Usage: $0 ALBUM_FOLDER|ALBUM_ZIP"
    exit 1
fi

input=$1

if [[ -d "$input" ]]; then
    albumFolder=$(realpath "$input")
elif [[ -f "$input" && "${input,,}" == *.zip ]]; then
    tmpDir=$(mktemp -d)
    unzip -q "$input" -d "$tmpDir"
    albumFolder=$tmpDir
else
    echo "Input must be a single album folder or a zip file"
    exit 1
fi

albumArtistsBefore=$(beet ls -af '$albumartist\t$album' added-)
echo "$albumArtistsBefore"
echo "Importing $albumFolder"
beet import "$albumFolder"
albumArtistsAfter=$(beet ls -af '$albumartist\t$album' added-)
numAddedAlbums=$(diff <(echo -E "$albumArtistsBefore") <(echo -E "$albumArtistsAfter") | awk '/^>/ { count++ } END { print count + 0 }')
artists=$(beet ls -af '$albumartist' added- | head -n "$numAddedAlbums")
albums=$(beet ls -af '$album' added- | head -n "$numAddedAlbums")
for i in $(seq 1 "$numAddedAlbums"); do
    artist=$(echo -E "$artists" | head -n "$i" | tail -n 1)
    album=$(echo -E "$albums" | head -n "$i" | tail -n 1)
    echo "Adding: \"$artist\", \"$album\""
    echo "\"$artist\", \"$album\"" >> "$musicFolder/quarantine"
done
