{
  inputs,
  pkgs,
  ...
}: let
  maily = inputs.maily.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  environment.systemPackages = [maily];
  networking.hosts."127.0.0.1" = ["maily.localhost"];

  systemd.user.services.maily = {
    description = "Maily local webmail";
    wantedBy = ["default.target"];
    after = ["network-online.target"];
    wants = ["network-online.target"];
    serviceConfig = {
      ExecStart = "${maily}/bin/maily --listen 127.0.0.1:3000";
      Restart = "on-failure";
      RestartSec = "2s";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."maily.localhost" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 80;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };
}
