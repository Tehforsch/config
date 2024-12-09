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

echo "Building nixos"
nixos-rebuild --option tarball-ttl 0 switch --target-host $1 --build-host $1 --use-remote-sudo --flake $config/nixos/#$1 
