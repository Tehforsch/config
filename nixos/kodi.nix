{ config, pkgs, ... }:
{

  services.displayManager.autoLogin = {
    enable = true;
    user = "kodi";
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

  users.users.kodi = {
    isNormalUser = true;
    description = "Kodi Media Center";
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

  boot.kernelParams = [
    "cma=128M"
  ];
}
