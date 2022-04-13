#!/bin/bash
#
if [ $# -eq 0 ]; then
   echo "Need system name as input"
   exit 1
fi

export SYSTEM_NAME=$1

mkdir -p "$HOME/.config/systemName/"
echo $SYSTEM_NAME > $HOME/.config/systemName/name

cd "$(dirname "$0")"
DOTFILES_ROOT=$(pwd)

$DOTFILES_ROOT/symlinks.sh

for installer in $(find "$DOTFILES_ROOT/" -name "install.sh"); do
    echo "Running '${installer}'"
    "${installer}"
    if [[ $? ]]; then
        echo "successfully ran $installer"
    else
        echo "failed to run $installer"
        exit 1
    fi
done
