# This is a little shitty, but it does the job
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
ssh-add ~/.ssh/id_rsa
nixos-rebuild switch --target-host netcup --build-host netcup --use-remote-sudo --flake $config/nixos/#netcup
