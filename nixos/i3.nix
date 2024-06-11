{ config, pkgs, ... }:
{
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };
   
    displayManager = {
        defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status
        i3lock
     ];
    };
  };
  environment.systemPackages = with pkgs; [
    rofi
  ];
}
