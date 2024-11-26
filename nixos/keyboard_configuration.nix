{ pkgs, ... }:

{
  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  services.xserver.displayManager.sessionCommands =
    "${pkgs.xorg.xmodmap}/bin/xmodmap /home/toni/projects/config/xmodmap/xmodmapNormal";
}
