remainTime=300
timerDir="$( cd "$(dirname "$0")" ; pwd -P )"
for i in $(seq 1 $1); do
    sleep 1
done
aplay $timerDir/beep.wav
sleep 1
aplay $timerDir/beep.wav
sleep 1
aplay $timerDir/beep.wav
sleep 1
sleep $remainTime