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
    ripgrep # rg
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
    usbutils
    dunst # notification daemon

    # Sound + Music
    pavucontrol
    pulseaudio # for pactl etc? even though i have pipewire
    mpd
    mpc-cli
    mpdas
    libnotify

    docker
    docker-compose
    zoom-us
  ];
}