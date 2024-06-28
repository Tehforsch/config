{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    light
    qbittorrent
    zoom-us
    acpi
  ];
}
