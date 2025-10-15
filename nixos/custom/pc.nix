{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    reaper
    borgbackup
    beets
    wineWowPackages.stable
    yabridge
    yabridgectl
    qbittorrent
    steam
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.graphics.enable32Bit = true;

  # For reapers HTTP web interface
  networking.firewall = {
    allowedTCPPorts = [ 8080 ];
    allowedUDPPorts = [ 8080 ];
  };
}
