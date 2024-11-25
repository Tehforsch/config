{ pkgs, ... }:
{
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  services.radicale = {
    enable = true;
    settings.server.hosts = [ "0.0.0.0:5232" ];
  };
  networking.firewall.allowedTCPPorts = [ 80 443 5232 ];

  services.murmur = {
    enable = true;
    openFirewall = true;
  };
}
