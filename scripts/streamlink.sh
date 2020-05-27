stream=$(echo "esl_dota2|cr1tdota|arteezy|gorgc|weplayesport_en|beyondthesummit" | rofi -sep "|" -dmenu -p "Choose stream:")
streamlink twitch.tv/$stream best
