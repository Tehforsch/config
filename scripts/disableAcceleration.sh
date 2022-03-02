# Set touchpad acceleration
for id in $(seq 15 20); do
    xinput set-prop $id "libinput Accel Speed" -0.0
done
# Disable acceleration for mouse
mouseId=$(xinput list | grep Mouse | cut -f 2 | sed "s/id=//")
xinput set-prop $mouseId "libinput Accel Speed" -1.0

# Increase speed slightly
mouseSpeed=1.00
xinput set-prop $mouseId "Coordinate Transformation Matrix" $mouseSpeed 0 0 0 $mouseSpeed 0 0 0 1
