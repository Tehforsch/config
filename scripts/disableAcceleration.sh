# Disable mouse acceleration, should be some id between 10-12 
for id in $(seq 1 15); do
    # xinput set-prop $id "libinput Accel Speed" -1.0
done
