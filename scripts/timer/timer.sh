remainTime=300
timerDir="$( cd "$(dirname "$0")" ; pwd -P )"
sleep $1
for i in $(seq 1 10000); do
    paplay $timerDir/beep.wav
    sleep 1
done
