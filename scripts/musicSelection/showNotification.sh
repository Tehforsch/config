message="$(mpc current -f "%artist% - %album% - %title%")"
# the canonical-private-synchronous info makes sure that this notification replaces itself (so we dont see previous albums anymore when we call this script again)
notify-send "$message" -t 2000
