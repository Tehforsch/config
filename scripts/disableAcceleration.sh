# Set touchpad acceleration
for id in $(seq 11 20); do
    xinput set-prop $id "libinput Accel Speed" -0.0
done
# Disable acceleration for mouse
mouseId=$(xinput list | grep Mouse | grep pointer | grep -v Consumer |  cut -f 2 | sed "s/id=//")
echo $mouseId
xinput set-prop $mouseId "libinput Accel Speed" -1.0

mouseSpeed=1.00
xinput set-prop $mouseId "Coordinate Transformation Matrix" $mouseSpeed 0 0 0 $mouseSpeed 0 0 0 1
