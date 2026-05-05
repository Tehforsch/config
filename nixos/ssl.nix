{...}: {
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
      locations."/calibre/" = {
        proxyPass = "http://127.0.0.1:8083/";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Scheme $scheme;
          proxy_set_header X-Script-Name /calibre;
          proxy_redirect off;
        '';
      };
      locations."/todo/" = {
        proxyPass = "http://127.0.0.1:8337/";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_redirect off;
        '';
      };
      locations."/rss/" = {
        proxyPass = "http://127.0.0.1:7000/";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_redirect off;
        '';
      };
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
    virtualHosts."rolf.tonipeter.de" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3001";
        extraConfig = ''
          client_max_body_size 200M;
          proxy_read_timeout 300s;
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };

  # Open firewall ports
  networking.firewall.allowedTCPPorts = [80 443];
}
