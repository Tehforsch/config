#!/bin/bash
cd ~
docs=""
command=$1
shift # Filetypes are now the only remaining arguments
# Put the lower-depth results on top of the list
maxDepth=3 # we cant do this for all the depths because the query will take too long for it to be fun
filetypeCommand=""
for filetype in "$@"; do
    filetypeCommand=$filetypeCommand" -e $filetype"
done

for depth in $(seq 0 $maxDepth); do
    searchResult=$(fd -E projects/cluster $filetypeCommand --exact-depth $depth)
    if [ "$searchResult" != "" ]; then
        if [ "$docs" != "" ]; then
            docs="${docs}\n$searchResult"
        else
            docs="$searchResult"
        fi
    fi
done
docs=$docs$(fd $filetypeCommand --min-depth $(( $maxDepth + 1 )))

file=$(printf "$docs" | rofi -i -dmenu -p  "Documents:" -no-custom)
if [ "$file" != "" ]; then
    $command "$file"
fi
