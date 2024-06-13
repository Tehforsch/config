{ config, lib, pkgs, modulesPath, ... }: {
  programs.hyprland.enable = true;
  programs.waybar.enable = true;

  services.keyd.enable = true;
  environment.etc."keyd/default.conf".source = ../keyd/default.conf;
  # https://github.com/rvaiya/keyd/issues/723
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
  systemd.services.keyd.serviceConfig.CapabilityBoundingSet = [ "CAP_SETGID" ];
  users.groups.keyd = { };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "Hyprland";
        user = "toni";
      };
      default_session = initial_session;
    };
  };

  environment.systemPackages = with pkgs; [
    rofi-wayland
    keyd
    hyprland-autoname-workspaces
    mako # notification server
    #for screenshots
    grim
    swappy
    slurp
  ];
}
