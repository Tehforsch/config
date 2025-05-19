prompt=$(rofi -i -dmenu)
if [[ "$prompt" == "take a break and think" ]]; then
    "$@"
fi
