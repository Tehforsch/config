{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    reaper
    borgbackup
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

  hardware.sane.enable = true;
  hardware.sane.drivers.scanSnap.enable = true;
}
