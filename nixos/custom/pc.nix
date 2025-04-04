{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    reaper
    borgbackup
    anki
    beets
    wineWowPackages.stable
    yabridge
    yabridgectl
    qbittorrent
    steam
  ];

  # For reapers HTTP web interface
  networking.firewall = {
    allowedTCPPorts = [ 8080 ];
    allowedUDPPorts = [ 8080 ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Without this setting, resuming after suspend would result in a
    # black screen and no graphical output whatsoever.
    powerManagement.enable = true;
    open = false;
  };

  services.paperless = {
    enable = true;
    user = "toni";
    dataDir = "/home/toni/.local/share/paperless";
    mediaDir = "/home/toni/resource/paperless";
    consumptionDir = "/home/toni/downloads/paperless";
    settings = {
      PAPERLESS_ADMIN_USER = "toni";
    };
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
