#!/bin/bash
# Adapted from original author: klaxalk (klaxalk@gmail.com, github.com/klaxalk)
# see https://github.com/klaxalk/i3-layout-manager
# removed saving/deleting and all rofi capabilities because i dont need them

# logs
LOG_FILE=/dev/null
ACTION="LOAD LAYOUT"
LAYOUT_FILE="$1"

# get current workspace ID
WORKSPACE_ID=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true).num' | cut -d"\"" -f2)

  # updating the workspace to the new layout is tricky
  # normally it does not influence existing windows
  # For it to apply to existing windows, we need to
  # first remove them from the workspace and then
  # add them back while we remove any empty placeholders
  # which would normally cause mess. The placeholders
  # are recognize by having no process inside them.

# get the list of windows on the current workspace
WINDOWS=$(xdotool search --all --onlyvisible --desktop $(xprop -notype -root _NET_CURRENT_DESKTOP | cut -c 24-) "" 2>/dev/null)

echo "About to unload all windows from the workspace" >> "$LOG_FILE"

for window in $WINDOWS; do

# the grep filters out a line which reports on the command that was just being called
# however, the line is not there when calling with rofi from i3
HAS_PID=$(xdotool getwindowpid $window 2>&1 | grep -v command | wc -l)

echo "Unloading window '$window'" >> "$LOG_FILE"

if [ $HAS_PID -eq 0 ]; then
    echo "Window '$window' does not have a process" >> "$LOG_FILE"
else
    xdotool windowunmap "$window" >> "$LOG_FILE" 2>&1
    echo "'xdotool windounmap $window' returned $?" >> "$LOG_FILE"
fi

done

echo "" >> "$LOG_FILE"
echo "About to delete all empty window placeholders" >> "$LOG_FILE"

# delete all empty layout windows from the workspace
# we just try to focus any window on the workspace (there should not be any, we unloaded them)
for (( i=0 ; $a-100 ; a=$a+1 )); do

# check window for STICKY before killing - if sticky do not kill
xprop -id $(xdotool getwindowfocus) | grep -q '_NET_WM_STATE_STICK'

if [ $? -eq 1 ]; then

    echo "Killing an unsued placeholder" >> "$LOG_FILE"
    i3-msg "focus parent, kill" >> "$LOG_FILE" 2>&1

    i3_msg_ret="$?"

    if [ "$i3_msg_ret" == 0 ]; then
    echo "Empty placeholder successfully killed" >> "$LOG_FILE"
    else
    echo "Empty placeholder could not be killed, breaking" >> "$LOG_FILE"
    break
    fi
fi
done

echo "" >> "$LOG_FILE"
echo "Applying the layout" >> "$LOG_FILE"

# then we can apply to chosen layout
i3-msg "append_layout $LAYOUT_FILE" >> "$LOG_FILE" 2>&1

echo "" >> "$LOG_FILE"
echo "About to bring all windows back" >> "$LOG_FILE"

# and then we can reintroduce the windows back to the workspace
for window in $WINDOWS; do

# the grep filters out a line which reports on the command that was just being called
# however, the line is not there when calling with rofi from i3
HAS_PID=$(xdotool getwindowpid $window 2>&1 | grep -v command | wc -l)

echo "Loading back window '$window'" >> "$LOG_FILE"

if [ $HAS_PID -eq 0 ]; then
    echo "$window does not have a process" >> "$LOG_FILE"
else
    xdotool windowmap "$window"
    echo "'xdotool windowmap $window' returned $?" >> "$LOG_FILE"
fi
done
