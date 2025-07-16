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
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    rofi
    wtype # Wayland alternative to xdotool
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
}
