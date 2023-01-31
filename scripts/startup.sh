scripts=~/projects/config/scripts
trayer --edge bottom --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --alpha 0 --tint 0x1d2021 --height 35 &
sleep 3 && $scripts/screenConfiguration.sh &
sleep 3 && $scripts/keyboardConfiguration.sh &
sleep 3 && $scripts/disableAcceleration.sh &
sleep 5 && $scripts/disablePowerSavingWhenSoundIsPlaying.sh &
/usr/bin/nm-applet &
seafile-applet &
sleep 3 && bash $scipts/redshiftDark.sh &
sleep 5 && mpd &
sleep 6 && mpdas &
task context none &
xfce4-power-manager &
bash $scripts/syncRepos.sh &
/opt/urserver/urserver --daemon &
gpaste-client start &
$scripts/refreshNewsboat.sh &
$scripts/lowerVolume.sh &
$scripts/updatePankit.sh &
