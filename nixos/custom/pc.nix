{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    reaper
    steam
    borgbackup
    anki
    beets
    wineWowPackages.stable
    yabridge
    yabridgectl
  ];

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

}