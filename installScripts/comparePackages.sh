#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
LIST_PACKAGES="pacman -Qeqn"
installedPackages=$($LIST_PACKAGES)
packagesInRepo=$(cat $SCRIPTPATH/packageList)
isDifferent=$(cmp <(echo $installedPackages | tr " " "\n" | sort) <(echo $packagesInRepo | tr " " "\n" | sort))
if [[ $isDifferent ]]; then
    echo "There are packages installed that are not in the package list or vice versa. Consider adding them to the package list (use pacman -Qeqn to generate package list)!"
    echo $(diff <(echo $installedPackages | tr " " "\n" | sort) <(echo $packagesInRepo | tr " " "\n" | sort))
else
    echo "All packages are up to date."
fi
