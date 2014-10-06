if [ $1 -eq 1 ]; then
    xbacklight -inc 10
fi
brightFloat=$(xbacklight)
brightInt=${brightFloat%.*}
if [ $1 -eq 0 ]; then
    if [ $brightInt -gt 10 ]; then
        xbacklight -dec 10
    fi
fi
echo $(xbacklight)
