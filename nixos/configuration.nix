{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./keyboard-configuration.nix
    ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "toniframework"; # Define your hostname.
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


  # Configure keymap in X11
  services.xserver = {
    enable = true;
    desktopManager = { xterm.enable = false; };
    displayManager = { 
      defaultSession = "none+i3"; 
    };
    layout = "de";
    xkbVariant = "nodeadkeys";
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
      ];
    };
  };

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


  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
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
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kitty
      firefox
      git
      thunderbird
      emacs
      openssh
      rustup
      fd
      zsh
      eza
      fzf
      bat
      telegram-desktop
      rofi
      gcc
      light
      oath-toolkit
    ];
  };

  fonts.packages = with pkgs; [
    jetbrains-mono
    dejavu_fonts
    noto-fonts
    hack-font
    inconsolata
  ];

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "toni";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  programs.zsh.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";
}
