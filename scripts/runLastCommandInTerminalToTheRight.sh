export SWAYSOCK="${SWAYSOCK:-$(find /run/user/$(id -u) -name 'sway-ipc.*.sock' 2>/dev/null | head -1)}"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-$(ls /run/user/$(id -u) | grep wayland | head -1)}"
swaymsg focus right
wtype -M ctrl p -m ctrl
wtype -k Return
swaymsg focus left
