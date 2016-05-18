if [ $1 -eq 1 ]; then
    xbacklight -inc 10
fi
brightFloat=$(xbacklight)
brightInt=${brightFloat%.*}
if [ $1 -eq -1 ]; then
    if [ $brightInt -gt 10 ]; then
        xbacklight -dec 10
    fi
fi
if [ $1 -eq 0 ]; then
    if [ $brightInt -eq 0 ]; then
        xbacklight -set 100
    else
        xbacklight -set 0
    fi
fi
echo $(xbacklight)
