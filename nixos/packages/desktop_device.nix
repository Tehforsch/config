{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Developer stuff
    kitty
    emacs
    meld
    mold-wrapped

    # Programming languages
    uv
    ruff
    rustup # This is nice for new projects and diving through external libraries where direnv doesn't really work.
    nil # language server for nix

    # User applications
    firefox
    betterbird
    vlc
    spotify
    discord
    telegram-desktop
    keepassxc
    inkscape
    gimp
    libreoffice
    xfce.thunar
    zathura
    nomacs
    zoom-us

    # Utilities
    usbutils
    dunst # notification daemon
    (ffmpeg.override { withXcb = true; })
    arandr
    xfce.tumbler
    ffmpegthumbnailer
    dust
    ripgrep-all
    flameshot
    xclip
    xrectsel

    # Network stuff
    oath-toolkit
    openvpn
    openssh
    openconnect
    networkmanager-openconnect
    openssl

    # Sound + Music
    pavucontrol
    pulseaudio # needed for pactl etc. even though i have pipewire
    mpd
    mpc-cli
    mpdas
    libnotify
    alsa-lib
  ];

  programs.direnv.enable = true;
}
