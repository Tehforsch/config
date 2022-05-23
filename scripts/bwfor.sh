#!/bin/bash
# Exactly not how it should be done but my phone cant possibly be part of my workflow
sleep 1
otp=$(oathtool --totp --base32 $(cat ~/.ssh/bwfor2fa))
for (( i=0; i<${#otp}; i++ )); do
    xdotool key "${otp:$i:1}"
done
xdotool key return
sleep 2
pw=$(cat ~/.ssh/bwfor)
for line in $pw; do
    xdotool key $line
done
xdotool key return
