#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
LIST_PACKAGES="pip freeze"
installedPackages=$($LIST_PACKAGES)
packagesInRepo=$(cat $SCRIPTPATH/pythonModuleList)
isDifferent=$(cmp <(echo $installedPackages | tr " " "\n" | sort) <(echo $packagesInRepo | tr " " "\n" | sort))
if [[ $isDifferent ]]; then
    echo "There are python modules installed that are not in the list or vice versa. Consider adding them to the module list (use ${LIST_PACKAGES} to generate list)!"
    echo $(diff <(echo $installedPackages | tr " " "\n" | sort) <(echo $packagesInRepo | tr " " "\n" | sort))
else
    echo "All python are up to date."
fi
