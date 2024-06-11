{ config, pkgs, ... }:
{
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };
   
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status
        i3lock
     ];
    };

    xkb.layout = "de";
    xkb.variant = "nodeadkeys";
  };
  services.displayManager = {
    defaultSession = "none+i3";
  };

  environment.systemPackages = with pkgs; [
    rofi
  ];
}
