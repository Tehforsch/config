{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ urserver ];

  networking.firewall = {
    allowedTCPPorts = [ 7745 ];
    allowedUDPPorts = [ 7745 ];
  };

  services.homebox = {
    enable = true;
    settings = {
      HBOX_STORAGE_DATA = "/var/lib/homebox/data";
      HBOX_STORAGE_SQLITE_URL = "/var/lib/homebox/data/homebox.db?_pragma=busy_timeout=999&_pragma=journal_mode=WAL&_fk=1";
      HBOX_OPTIONS_ALLOW_REGISTRATION = "false";
      HBOX_MODE = "production";
    };
  };
}
