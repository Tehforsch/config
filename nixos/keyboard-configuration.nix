{ config, pkgs, ... }:

{
  services.xserver.displayManager.sessionCommands =
    "${pkgs.xorg.xmodmap}/bin/xmodmap /home/toni/projects/config/xmodmap/xmodmapNormal";
}
