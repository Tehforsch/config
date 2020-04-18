dataFile=~/resource/tracker/data
touch $dataFile
while true; do
    sleep 3600
    result=$(zenity --entry)
    echo "$(date +"%Y-%m-%d-%H-%M-%S") $result" >> $dataFile
done
