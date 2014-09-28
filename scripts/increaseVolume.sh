#Get volume of the pulse audio source $id
id=1
line=$(expr 1 + $id + $id)
volume=$(pactl list | ~/.bin/ack Volume | head -n $line | tail -n 1 | ~/.bin/ack "Volume: 0:[\s]* ([\d]*)%" --output=\$1)
echo "Current volume : $volume"
#If volume is > 100-increase (that means no overdrive going on if we increase by increase%) then increase the volume
increase=10
maxVolume=90
maxVolume=$(expr $maxVolume - $increase)
if [ "$volume" -le "$maxVolume" ]; then
    pactl set-sink-volume $id -- +$increase%
fi
