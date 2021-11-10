#!/bin/bash
file=$1
minDiff=$2
shift
shift
command=$@

lastDate=$(date -r $file +%s)
now=$(date +%s)
diff=$((now - lastDate))

if (( $diff > $minDiff )); then
    i3-msg exec $command
    touch $file
else 
    remaining=$(($minDiff - $diff))
    echo "Still remaining: $remaining"
fi
