{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    qbittorrent
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
