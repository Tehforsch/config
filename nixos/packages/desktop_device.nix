{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Developer stuff
    kitty
    meld
    mold-wrapped

    # Programming languages
    uv
    ruff
    python312Packages.python-lsp-server
    nil # language server for nix
    elan

    # User applications
    firefox
    thunderbird
    vlc
    spotify
    discord
    keepassxc
    inkscape
    gimp
    zathura
    pcmanfm
    nomacs
    zoom-us
    numbat
    python3 # I sometimes want a REPL, so having this always there is nice
    obsidian
    hotspot
    anki
    evince # for editing pdf forms
    wdisplays
    claude-code
    rmpc
    sqlite
    alejandra # nix formatter
    prettier
    lean4

    # Reactivate this once I dont rebuild this once every day
    # inputs.torga.packages.x86_64-linux.torga-cli
    inputs.mpd_rofi.packages.x86_64-linux.default

    # Utilities
    usbutils
    dunst # notification daemon
    (ffmpeg.override { withXcb = true; })
    arandr
    xfce.tumbler
    ffmpegthumbnailer
    dust
    ripgrep-all
    xclip
    xrectsel
    perf
    bottom
    nh
    bacon
    flameshot
    android-tools
    scrcpy
    gvfs          # Virtual filesystem with MTP support

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
    mpc
    libnotify
    alsa-lib
  ];

  programs.direnv.enable = true;
}
