{
  inputs,
  pkgs,
  ...
}: {
  services.radicale = {
    enable = true;
    settings = {
      server.hosts = ["0.0.0.0:5232"];
      auth.type = "none";
    };
  };

  services.murmur = {
    enable = true;
    openFirewall = true;
  };

  services.miniflux = {
    enable = true;
    adminCredentialsFile = "/home/toni/resource/keys/on_server/miniflux";
    config = {
      LISTEN_ADDR = "0.0.0.0:7000";
    };
  };

  systemd.services.miniflux = {
    wantedBy = pkgs.lib.mkForce [];
  };

  systemd.timers."miniflux-start" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 17:00:00";
      Persistent = true;
    };
  };

  systemd.services."miniflux-start" = {
    description = "Start Miniflux RSS service";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl start miniflux.service";
    };
  };

  systemd.timers."miniflux-stop" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 04:00:00";
      Persistent = true;
    };
  };

  systemd.services."miniflux-stop" = {
    description = "Stop Miniflux RSS service";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl stop miniflux.service";
    };
  };

  systemd.user.services.torga = {
    enable = true;
    description = "torga";
    wantedBy = ["default.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${inputs.torga.packages.x86_64-linux.torga-server}/bin/torga-server";
      Restart = "on-failure";
    };
  };

  networking.firewall.allowedTCPPorts = [80 443 5232 7000 8337];
}
