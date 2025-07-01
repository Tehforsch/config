{ pkgs, ... }:
{
  services.paperless = {
    enable = true;
    user = "toni";
    dataDir = "/home/toni/.local/share/paperless";
    mediaDir = "/home/toni/resource/paperless";
    consumptionDir = "/var/lib/paperless/consume";
    consumptionDirIsPublic = true;
    settings = {
      PAPERLESS_ADMIN_USER = "toni";
    };
  };

  services.scanbd.enable = true;
}
