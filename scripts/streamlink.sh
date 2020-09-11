stream=$(echo "esl_dota2|weplayesport_en|beyondthesummit" | rofi -sep "|" -dmenu -p "Choose stream:")
streamlink twitch.tv/$stream best
