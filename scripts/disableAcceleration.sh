# Disable mouse acceleration, should be some id between 10-12 
for id in $(seq 15 20); do
    xinput set-prop $id "libinput Accel Speed" -0.0
done
mouseId=$(xinput list | grep Mouse | cut -f 2 | sed "s/id=//")
xinput set-prop $mouseId "libinput Accel Speed" -1.0
