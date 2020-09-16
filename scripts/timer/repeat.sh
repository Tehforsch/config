timerDir="$( cd "$(dirname "$0")" ; pwd -P )"
for i in $(seq 1 10000); do
    paplay $timerDir/beep.wav
    sleep 60
done
