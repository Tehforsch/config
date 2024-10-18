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
    htop
    gcc
    libclang
    gnumake
    cmake
    pkg-config
    ruff
    (python3.withPackages (p: with p; [ numpy python-lsp-server pyyaml ]))
    meld
    jq
    direnv
    nushell
    inkscape
    xrectsel
    mold-wrapped
    clang
    # This is nice for new projects and diving through external libraries where
    # direnv doesn't really work.
    rustup
    dust

    # Network stuff
    oath-toolkit
    openvpn
    openssh
    openconnect
    networkmanager-openconnect
    openssl

    # User applications
    firefox
    vlc
    thunar
    syncthing
    steam
    thunderbird
    redshift
    zathura
    flameshot
    nomacs
    usbutils
    dunst # notification daemon
    (ffmpeg.override { withXcb = true; })
    spotify
    discord
    arandr
    gimp
    dconf-editor
    telegram-desktop
    xfce.tumbler
    ffmpegthumbnailer

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

  programs.direnv.enable = true;
}
