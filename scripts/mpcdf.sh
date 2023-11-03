#!/bin/bash
# Exactly not how it should be done but my phone cant possibly be part of my workflow
sleep 0.1
pw=$(cat ~/.ssh/mpcdf)
for line in $pw; do
    xdotool key $line
done
xdotool key return
sleep 2
otp=$(oathtool --totp --base32 $(cat ~/.ssh/mpcdf2fa))
echo $otp
for (( i=0; i<${#otp}; i++ )); do
    xdotool key "${otp:$i:1}"
done

xdotool key return
sleep 3
pw=$(cat ~/.ssh/mpcdf)
for line in $pw; do
    xdotool key $line
done
xdotool key return
