{ config, pkgs, ... }: {
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
      alacritty # Recommended terminal emulator
      dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
      grim # Screenshot functionality
      slurp # Screenshot functionality
    ];
    extraOptions = ["--unsupported-gpu"];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.sway}/bin/sway --unsupported-gpu";
        user = "toni";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    rofi
    wtype # Wayland alternative to xdotool
    i3wsr
    i3status # Status generator for swaybar
  ];

  # Enable polkit for authentication
  security.polkit.enable = true;

  # Enable XDG portal for screen sharing and other desktop integration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # This can probably be done much easier but I couldnt figure out how to
  # and it was a nice way to explore some of nix's capabilities
  systemd.user.services.i3wsr =
    let i3wsr-starter = pkgs.writeShellScript "i3wsr-starter" ''
      # Important: sway --get-socketpath only returns the value
      # of $SWAYSOCK, but this isn't set in systemd services.
      export I3SOCK=/run/user/$(id -u)/sway-ipc.$(id -u).$(${pkgs.procps}/bin/pgrep -x sway).sock
      ${pkgs.i3wsr}/bin/i3wsr
    ''; in
    {
      enable = true;
      description = "i3wsr";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${i3wsr-starter.outPath}";
        Restart = "always";
      };
      path = with pkgs; [
        i3wsr-starter
        procps
      ]; 
    };

}
