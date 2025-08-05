echo "This script assumes that $1 is the ssh alias and the name of the nixos configuration"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
ssh-add ~/.ssh/id_rsa

secrets_dir="$HOME/resource/keys/on_server/"
if [[ -d "$secrets_dir" ]]; then
    echo "Copying secrets"
    ssh $1 mkdir -p resource/keys/on_server/
    rsync -a "$secrets_dir"/ $1:resource/keys/on_server/
fi
syncthing_keys_dir="$HOME/resource/keys/syncthing/$1"
if [[ -d "$syncthing_keys_dir" ]]; then
    echo "Copying syncthing keys"
    ssh $1 mkdir -p resource/keys/syncthing/$1
    rsync -a "$syncthing_keys_dir"/ $1:resource/keys/syncthing/$1
fi

echo "Building nixos"
nixos-rebuild switch --target-host $1 --build-host $1 --sudo --ask-sudo-password --flake $config/nixos/#$1 
