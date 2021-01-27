searchSpace=$(mpc current -f "%artist% %title%")
searchPlus=$(echo "$searchSpace" | sed "s/ /+/g" )
directString=$(echo "$searchSpace" | sed "s/ /-/g" | sed "s/\.//g")
directUrl="https://genius.com/$directString-lyrics"
num404ErrorLines=$(curl --silent "$directUrl" | grep "render_404" | wc -l)
if [[ $num404ErrorLines == 0 ]]; then 
    firefox --new-window "$directUrl"
else
    firefox --new-window https://genius.com/search?q=$searchPlus
fi
