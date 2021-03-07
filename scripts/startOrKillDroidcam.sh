id=$(pgrep droidcam-cli | wc -l)
if [[ $id == 1 ]]; then
    killall droidcam-cli
else
    nohup droidcam-cli adb 4747&
fi
