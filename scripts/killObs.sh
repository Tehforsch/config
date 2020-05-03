# Kill OBS after some time. This is triggered when switching out of game mode but I don't want to kill and start obs everytime I switch (which happens a lot). The idea is to kill OBS after a few minutes of this script and to kill this script when going into game mode again, thus hopefully running obs for as long as I am playing anything.
sleep 600 && pkill obs
