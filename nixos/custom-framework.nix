{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    light
    qbittorrent
  ];
}
