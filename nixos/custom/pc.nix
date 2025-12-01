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

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      media = {
        path = "/home/toni/movies";
        browseable = "yes";
        "read only" = "yes";
        "valid users" = "toni";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };

  systemd.services.copy-keepass-db = {
    description = "Copy KeePass database to phone directory";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "toni";
      ExecStart = "${pkgs.coreutils}/bin/cp /home/toni/resource/keys/keepass/Passwords.kdbx /home/toni/resource/phone/";
      RemainAfterExit = true;
    };
  };
}
