{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Developer stuff
    kitty
    zsh
    vim
    git
    delta
    git
    emacs
    fd
    eza
    fzf
    bat
    silver-searcher # ag
    ripgrep
    ripgrep-all
    unp
    killall
    nil
    zip
    unzip
    mold
    htop
    rustup # Keeping this here for convenience, although dev shells can substitute this well
    gcc
    gnumake
    pkg-config
    ruff
    (python3.withPackages (p: with p; [ numpy python-lsp-server ]))

    # Network stuff
    oath-toolkit
    openvpn
    openssh
    openconnect
    openssl

    # User applications
    firefox
    vlc
    pcmanfm
    syncthing
    steam
    thunderbird
    redshift
    zathura
    flameshot
    nomacs
    usbutils
    dunst # notification daemon

    # Sound + Music
    pavucontrol
    pulseaudio # for pactl etc? even though i have pipewire
    mpd
    mpc-cli
    mpdas
    libnotify
    alsa-lib

    docker
    docker-compose
    zoom-us
  ];
}
