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

  users.users.github-runner = {
    isSystemUser = true;
    group = "github-runner";
  };
  users.groups.github-runner = {};

  systemd.tmpfiles.rules = [
    "d /var/lib/github_runner/sokobrane 0700 github-runner github-runner -"
  ];

  services.github-runners.netcup = {
    enable = true;
    name = "netcup_sokobrane";
    url = "https://github.com/tehforsch/sokobrane";
    tokenFile = "/home/toni/resource/keys/on_server/github_runner/token";
    tokenType = "access";
    nodeRuntimes = ["node24"];
    replace = true;
    user = "github-runner";
    group = "github-runner";
    extraLabels = [
      "nixos"
      "x86_64-linux"
    ];
    workDir = "/var/lib/github_runner/sokobrane"; # the default /run/... is really small on netcup
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

  systemd.services.health_service_assistant = {
    enable = true;
    description = "health_service_assistant";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target"];
    wants = ["network-online.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${inputs.health_service_assistant.packages.x86_64-linux.default}/bin/health_service_assistant";
      WorkingDirectory = "/home/toni/resource/keys/on_server/health_service_assistant";
      Restart = "on-failure";
      RestartSec = 10;
      User = "toni";
    };
  };

  networking.firewall.allowedTCPPorts = [80 443 5232 7000 8083 8337];
}
