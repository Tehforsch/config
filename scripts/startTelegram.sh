lastDate=$(cat ~/.playground/telegramDate)
echo $lastDate
dateNow=$(date +%s)
echo $dateNow > ~/.playground/telegramDate
if (( $dateNow - $lastDate < 360 )); then
    diff=$(( ( $dateNow - $lastDate ) / 60 ))
    notify-send "$diff" -t 5000
fi

telegram-desktop
