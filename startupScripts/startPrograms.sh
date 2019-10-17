i3contexts="$HOME/projects/i3Contexts/switch.py"
scripts="$HOME/projects/config/scripts"

sleep 0.5
python3 $i3contexts workspace chat
/home/toni/.apps/Telegram/Telegram&
sleep 1

python3 $i3contexts workspace todo
$scripts/startChrome.sh --new-window todoist.com&
sleep 2

python3 $i3contexts workspace mail
$scripts/startChrome.sh --new-window mail.google.com&
thunderbird&
sleep 2

python3 $i3contexts workspace music
spotify&
