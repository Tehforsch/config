{ config, pkgs, ... }:
{

  services.displayManager.autoLogin = {
    enable = true;
    user = "toni";
  };
  services.xserver = {
    enable = true;
    displayManager = {
      lightdm = {
        enable = true;
        greeter.enable = false;
      };
    };
    desktopManager.kodi.enable = true;
  };

  users.users.toni = {
    extraGroups = [ "audio" "video" ];
  };

  hardware.graphics = {
    enable = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8080 ];
    allowedUDPPorts = [ 8080 ];
  };
}
