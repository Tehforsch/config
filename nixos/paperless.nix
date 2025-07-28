{ ... }:
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
      PAPERLESS_FILENAME_FORMAT="{{ title }}";
    };
  };

  hardware.sane.enable = true;
  hardware.sane.drivers.scanSnap.enable = true;
  users.users.toni.extraGroups = [ "scanner" "lp" "redis-paperless" ];

  # Disable sane-backends tests that hang
  nixpkgs.overlays = [
    (final: prev: {
      sane-backends = prev.sane-backends.overrideAttrs (oldAttrs: {
        doCheck = false;
        doInstallCheck = false;
      });
    })
  ];
}
