#!/usr/bin/env bash
scripts=/home/toni/projects/config/scripts
{ sleep 3; $scripts/screenConfiguration.sh; } &
{ sleep 3; $scripts/keyboardConfiguration.sh; } &
{ sleep 3; $scripts/disableAcceleration.sh; } &
/usr/bin/nm-applet& # network applet
redshift -l 49.494:8.650&
mpd&
mpdas&
xfce4-power-manager&
nextcloud&
syncthing serve --no-browser&
/opt/urserver/urserver --daemon&

$scripts/disablePowerSavingWhenSoundIsPlaying.sh &
$scripts/refreshNewsboat.sh&
$scripts/lowerVolume.sh&
$scripts/cleanUpHomeDirectory.sh&


kitty&
firefox&
# This sucks
sleep inf

