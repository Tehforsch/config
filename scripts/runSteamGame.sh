result=""
libraryPath="/run/media/extHdd/steam/steamapps/"
for f in $(fd -t f appmanifest "$libraryPath" --max-depth 1); do
    id=$(basename "$f" | sed "s/appmanifest_//" | sed "s/.acf//")
    name=$(cat "$f" | grep "name")
    name=${name:10:100}
    name=$(echo "$name" | sed "s/\"//g")
    if [[ "$name" = *"Steam Linux Runtime"*  ]]; then
        continue
    fi
    if [[ "$name" = *"Proton"*  ]]; then
        continue
    fi
    newline=$'\n'
    result="$name$newline$result"
    appids="$id$newline$appids"
done
index=$(echo "$result" | rofi -i -dmenu -p "Game:" -no-custom -format 'i')
if [[ $? == 0 ]]; then
    index=$((index + 1))
    appid=$(echo "$appids" | sed "${index}q;d")
    $CONFIG/scripts/runSteam.sh steam://rungameid/$appid
fi

