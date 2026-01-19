{lib, ...}: {
  networking.nameservers = ["1.1.1.1" "1.0.0.1"];

  services.blocky = {
    enable = true;
    settings = {
      upstream.default = ["1.1.1.1" "1.0.0.1"];

      blocking = {
        blackLists = {
          ads = ["https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro.txt"];
          productivity = ["file:///home/toni/resource/blocklist/productivity.txt"];
        };
        clientGroupsBlock = {
          default = ["ads" "productivity"];
        };
        refreshPeriod = "4h";
      };

      ports = {
        dns = 53;
        http = 4000;
      };

      bootstrapDns = "1.1.1.1";

      caching = {
        minTime = "5m";
        maxTime = "30m";
        prefetching = true;
      };

      queryLog = {
        type = "console";
      };
    };
  };

  systemd.services.blocky.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = lib.mkForce "toni";
    ProtectHome = lib.mkForce false;
  };

  networking.firewall = {
    allowedTCPPorts = [53 4000];
    allowedUDPPorts = [53];
  };
}
