{ inputs, pkgs, ... }:
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

  systemd.user.services.moody = {
    enable = true;
    description = "moody";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${inputs.moody.packages.x86_64-linux.default}/bin/python ${inputs.moody.packages.x86_64-linux.default}/lib/python3.12/site-packages/main.py";
    };
  };

  systemd.user.services.personalbot = {
    enable = true;
    description = "personalbot";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${inputs.personalbot.packages.x86_64-linux.default}/bin/python ${inputs.personalbot.packages.x86_64-linux.default}/lib/python3.12/site-packages/main.py";
      Restart = "on-failure";
    };

  };
}
