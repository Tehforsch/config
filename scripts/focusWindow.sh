# Switches focus to a specific program. If the program is not running it starts it.
# First argument: process name
# Second argument: command to run the program
# Third argument: x class name of program
# Find out if the program is opened, ignore this script and the ps/ack call which will count

count=$(ps aux | grep -v grep | grep -v focusWindow | grep -c $1)
echo $count
if [ $count -eq 0 ]; then
    $($2)
else
    i3-msg "[class=$3] focus"
fi
