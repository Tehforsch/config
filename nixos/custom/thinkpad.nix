{ pkgs, ... }:
{
  hardware.enableAllFirmware = true;
  environment.systemPackages = with pkgs; [
    gparted
  ];
  security.polkit.enable = true;
}
