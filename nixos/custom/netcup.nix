{
  inputs,
  pkgs,
  ...
}: let
  rolfPort = 3001;
  rolfHost = "127.0.0.1";
  rolfDomain = "rolf.tonipeter.de";
  rolfDataDir = "/home/toni/resource/rolf";
  rolfPackage = inputs.rolf.packages.${pkgs.system}.default;
  rolfUser = "toni";
in {
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

  users.users.${rolfUser}.linger = true;

  systemd.tmpfiles.rules = [
    "d ${rolfDataDir} 0750 ${rolfUser} users -"
    "d ${rolfDataDir}/db 0750 ${rolfUser} users -"
    "d ${rolfDataDir}/media 0750 ${rolfUser} users -"
    "d ${rolfDataDir}/media/audio 0750 ${rolfUser} users -"
    "d ${rolfDataDir}/media/video 0750 ${rolfUser} users -"
    "d ${rolfDataDir}/media/tmp 0750 ${rolfUser} users -"
    "d ${rolfDataDir}/secrets 0750 ${rolfUser} users -"
  ];

  systemd.user.services.rolf = {
    enable = true;
    description = "Rolf Band Practice App";
    after = ["default.target"];
    wantedBy = ["default.target"];

    environment = {
      NODE_ENV = "production";
      HOST = rolfHost;
      PORT = toString rolfPort;
      CORS_ORIGIN = "https://${rolfDomain}";
      DB_PATH = "${rolfDataDir}/db/rolf.db";
      MEDIA_DIR = "${rolfDataDir}/media";
      JWT_SECRET_FILE = "${rolfDataDir}/secrets/jwt-secret";
      ROLF_PASSWORD_HASH_FILE = "${rolfDataDir}/secrets/password-hash";
    };

    serviceConfig = {
      Type = "simple";
      WorkingDirectory = rolfDataDir;
      ExecStart = "${pkgs.nodejs_20}/bin/node ${rolfPackage}/server/dist/index.js";
      Restart = "always";
      RestartSec = 5;
      UMask = "0077";
      NoNewPrivileges = true;
      PrivateTmp = true;
    };
  };

  networking.firewall.allowedTCPPorts = [80 443 5232 7000 8083 8337];
}
