#!/bin/zsh

param=$1
if [ "$param" = "full" ]; then
    full=true
else
    full=false
fi

python "$CONFIG/pythonScripts/addTimed.py"
red='\e[0;31m'
blue='\e[0;34m'
nc='\e[0m' # No Color

function redEcho {
    echo -e "${red}$1${nc}"
}
function blueEcho {
    echo -e "${blue}$1${nc}"
}
function printFile {
    for f in ./*
    do
        # Is directory
        if [ -d $f ]; then
            # File is not empty
            if [ -s $f/$1 ]; then
                # GO
                blueEcho "$(basename $f)"
                cat $f/$1
            fi
        fi
    done
}
if $full; then
    redEcho "Timed"
    printFile timed
    echo "-----------------------------------------------"
    redEcho "Someday / Maybe"
    printFile somedayMaybe
    redEcho "Waiting"
    printFile waiting
fi
redEcho "Next Actions:"
printFile nextActions
