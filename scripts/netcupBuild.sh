set -e

branch=$1

cd ~/projects/config
git fetch
git reset --hard origin/$branch

echo "Pulled from git"
sudo -S nixos-rebuild switch --flake ~/projects/config/nixos#netcup
bash symlinks.sh
