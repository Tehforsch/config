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
      LISTEN_ADDR = "127.0.0.1:7000";
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

  services.calibre-web = {
    enable = true;
    listen = {
      ip = "0.0.0.0";
      port = 8083;
    };
    options = {
      calibreLibrary = "/var/lib/calibre-web/library";
      enableBookUploading = true;
    };
    package = pkgs.calibre-web.overridePythonAttrs (old: {
      dependencies =
        old.dependencies
        ++ [pkgs.python3Packages.jsonschema];
    });
  };

  networking.firewall.allowedTCPPorts = [80 443 5232 7000 8083 8337];
}
