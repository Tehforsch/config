function shell {
    if [[ "$#" -eq 1 ]]; then
        nix develop $CONFIG/nixos/shells#$1 -c zsh
    else 
        echo "Need an argument."
    fi
}

function dev {
    if [[ "$#" -eq 2 ]]; then
        nix develop "$1"#$2 -c zsh
    elif [[ "$#" -eq 1 ]]; then
        nix develop "$1" -c zsh
    else 
        nix develop . -c zsh
    fi
}
