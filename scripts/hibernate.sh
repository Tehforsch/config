# This script can be run when the powerbutton is pressed by modifying /etc/acpi/powerbtn.sh to call it as well as
# adding a line like
#HandlePowerKey=poweroff
# to /etc/systemd/logind.conf
# and running
# sudo service systemd-logind restart
# sudo acpid restart
# For some reason this script will then be run multiple times when the power button is pressed which might re-hibernate the computer just after boot which is very annoying.

# Pauses spotify (otherwise scary sounding half-speed playback before the hibernate and then music will immediately resume on reboot both of which are bad :D)
sudo -u toni dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause
# hibernate
sudo pm-hibernate
