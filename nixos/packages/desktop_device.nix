{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Developer stuff
    kitty
    emacs30
    meld
    mold-wrapped

    # Programming languages
    uv
    ruff
    python312Packages.python-lsp-server
    rustup # This is nice for new projects and diving through external libraries where direnv doesn't really work.
    nil # language server for nix

    # User applications
    firefox
    thunderbird
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
    numbat
    python3 # I sometimes want a REPL, so having this always there is nice
    obsidian
    hotspot
    anki
    evince # for editing pdf forms

    # Ever since wayland, I've had difficulties with some
    # bevy applications when I initialize their vulkan/wayland
    # dependencies in a devshell instead of using a system-wide
    # installation. I don't care enough to do this properly anymore
    # since I already wasted hours on this, so here they are in my
    # global installation. Add them with
    # LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/run/current-system/sw/lib
    vulkan-loader
    wayland
    wayland-protocols

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
    linuxKernel.packages.linux_zen.perf
    wl-clipboard-rs
    bottom

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
    mpc-cli
    libnotify
    alsa-lib
  ];

  programs.direnv.enable = true;
}
