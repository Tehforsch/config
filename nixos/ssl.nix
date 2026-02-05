{ ... }:
{
  # ACME configuration
  security.acme = {
    acceptTerms = true;
    defaults.email = "mail@tonipeter.de";
  };

  # Nginx with ACME
  services.nginx = {
    enable = true;
    virtualHosts."tonipeter.de" = {
      root = "/var/www/html/tonipeter.de";
      enableACME = true;
      forceSSL = true;
    };
    virtualHosts."rss.tonipeter.de" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:7000";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
    virtualHosts."home.shark.fish" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8123";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };

  # Open firewall ports
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
