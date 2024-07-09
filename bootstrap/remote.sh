# Make sure sshd runs and git is installed.
# Connect to wifi via
# nmcli device wifi connect Connect-to-this password iampassword123

if [[ $# == 1 ]]; then
    SYSTEM_NAME=$1
else
    echo "target hostname of new system is required"
    exit 1
fi

CONFIG=~/projects/config
mkdir -p $(dirname $CONFIG)
ssh-keyscan github.com >> .ssh/known_hosts
git clone git@github.com:tehforsch/config $CONFIG
cp /etc/nixos/hardware-configuration.nix $CONFIG/nixos/hardware-$SYSTEM_NAME.nix
cd $CONFIG
bash symlinks.sh $SYSTEM_NAME

echo "TO SWITCH: "
echo sudo -u toni nixos-rebuild switch --flake $CONFIG#$SYSTEM_NAME
