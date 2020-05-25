#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
LIST_PACKAGES="pacman -Qeqn"
installedPackages=$($LIST_PACKAGES | sort)
systemName=$(cat ~/.systemName)
localPackagesInRepo=$(cat $SCRIPTPATH/${systemName}PackageList)
globalPackagesInRepo=$(cat $SCRIPTPATH/packageList)
packagesInRepo=$(printf "$localPackagesInRepo\n$globalPackagesInRepo" | sort)
isDifferent=$(cmp <(echo "$installedPackages") <(echo "$packagesInRepo"))
if [[ $isDifferent ]]; then
    echo "There are packages installed that are not in the package list or vice versa. Consider adding them to the package list (use listPackages.sh to generate package list)!"
    echo "Packages in repo that are not yet installed:"
    difference=$(diff <(echo "$installedPackages") <(echo "$packagesInRepo"))
    echo "$difference" | grep ">" | tr ">" " "
    echo "Packages that are installed but not in repo:"
    echo "$difference" | grep "<" | tr "<" " "
    # echo $(diff <(echo $installedPackages | tr " " "\n" | sort) <(echo $packagesInRepo $localPackagesInRepo | tr " " "\n" | sort)) | tr "<" "<\n" | tr ">" ">\n"
else
    echo "All packages are up to date."
fi
