#!/bin/bash
if [[ $1 == "sim" ]]; then
    a="run"
    b="simulations"
fi
if [[ $1 == "run" ]]; then
    a="simulations"
    b="run"
fi

pwd=$(pwd)
if [[ $pwd == *"phd/$a/"* ]]; then
    newDir=${pwd/$a/$b}
else
    newDir=~/projects/phd/$b
fi
if [[ $pwd == *"phd/$b/"* ]]; then
    echo -E ""
else
    while ! [[ -d $newDir ]]; do
        newDir=$(dirname $newDir)
        echo $newDir
    done
    cd $newDir
fi
