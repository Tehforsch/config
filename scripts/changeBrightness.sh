# Taken from edi9999 from https://stackoverflow.com/questions/23866335/arch-xbacklight-no-outputs-have-backlight-property
file=/sys/class/backlight/intel_backlight/brightness
current=$(cat "$file")
new="$current"
if [ "$1" = "-inc" ]
then
    new=$(( current + $2 ))
fi
if [ "$1" = "-dec" ]
then
    new=$(( current - $2 ))
fi
if [ "$1" = "-set" ]
then
    new=$2
fi
echo "$new" | tee "$file"
