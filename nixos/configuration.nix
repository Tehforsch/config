{ config, pkgs, journal, ... }:

{
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "toni";

  services.emacs = {
    enable = true;
    defaultEditor = true;
  };

  services.actkbd = {
    enable = true;
      bindings = [
        { keys = [ 232 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
        { keys = [ 233 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
      ];
  };


  # Enable sound with pipewire.
  sound.enable = true;
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  users.users.toni = {
    isNormalUser = true;
    description = "toni";
    extraGroups = [ "networkmanager" "wheel" "video" "input" "keyd" ];
    shell = pkgs.zsh;
  };
  services.syncthing = {
    enable = true;
    user = "toni";
    dataDir = "/home/toni/Syncthing";
    configDir = "/home/toni/.config/syncthing";   # Folder for Syncthing's settings and keys
  };

  fonts.packages = with pkgs; [
    jetbrains-mono
    dejavu_fonts
    noto-fonts
    hack-font
    inconsolata
    font-awesome
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.pulseaudio = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    kitty
    firefox
    git
    vlc
    emacs
    openssh
    rustup
    fd
    zsh
    eza
    fzf
    bat
    telegram-desktop
    signal-desktop
    gcc
    light
    oath-toolkit
    silver-searcher
    qbittorrent
    ripgrep
    openvpn
    syncthing
    unp
    steam
    redshift
    pavucontrol
    pulseaudio # for pactl etc? even though i have pipewire
    killall
    mpd
    mpc-cli
    libnotify
    thunderbird
    newsboat
    zathura
    journal.packages.x86_64-linux.journal
  ];

  services.mpd = {
    enable = true;
    user = "toni";
    musicDirectory = "/home/toni/music";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "MPD output"
      }
    '';
    startWhenNeeded =
      true; # systemd feature: only start MPD service upon connection to its socket
  };
  systemd.services.mpd.environment = {
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
    XDG_RUNTIME_DIR =
      "/run/user/1000"; # User-id 1000 must match above user. MPD will look inside this directory for the PipeWire socket.
  };

  programs.zsh.enable = true;
  programs.nm-applet.enable = true;
  programs.openvpn3.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";
}
