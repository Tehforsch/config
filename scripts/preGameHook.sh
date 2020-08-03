setxkbmap -layout de -variant nodeadkeys
xmodmap /home/toni/projects/config/xmodmap/xmodmapGames
bash /home/toni/projects/config/scripts/disableAcceleration.sh # This should already have run but make sure it is run
count=$(pgrep -c obs)
if [[ $count == 0 ]]; then
    # obs --startreplaybuffer --minimize-to-tray &
fi
# Kill obs killscript. see script for details
for id in $(pgrep -f killObs.sh); do
    echo $id
    kill $id
done
