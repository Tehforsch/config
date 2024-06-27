{ config, pkgs, inputs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
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
      {
        keys = [ 232 ];
        events = [ "key" ];
        command = "/run/current-system/sw/bin/light -U 10";
      }
      {
        keys = [ 233 ];
        events = [ "key" ];
        command = "/run/current-system/sw/bin/light -A 10";
      }
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
    extraGroups = [ "networkmanager" "wheel" "video" "input" "keyd" "audio" ];
    shell = pkgs.zsh;
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

  systemd.user.services.journal = {
    enable = true;
    description = "journal webserver";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${inputs.journal.packages.x86_64-linux.journal}/bin/journal";
    };
  };

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

  systemd.user.services.mpdas = {
    description = "mpdas last.fm scrobbler";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.mpdas}/bin/mpdas -c /home/toni/resource/keys/mpdasrc";
      Type = "simple";
    };
  };

  systemd.timers.refreshNewsboat = {
    wantedBy = [ "timers.target" ];
    partOf = [ "refreshNewsboat.service" ];
    timerConfig.OnCalendar = "hourly";
  };
  systemd.services.refreshNewsboat = {
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.newsboat}/bin/newsboat -u /home/toni/projects/config/newsboat/urls -C /home/toni/projects/config/newsboat/config -x reload
    '';
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
