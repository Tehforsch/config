function shell {
    if [[ "$#" -eq 1 ]]; then
        nix develop $CONFIG/nixos/shells#$1 -c zsh
    else 
        echo "Need an argument."
    fi
}
