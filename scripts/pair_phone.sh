# Pair with device first and then enter ip / port into the file
adb connect $(cat ~/.local/share/phone_ip_and_port)
scrcpy
