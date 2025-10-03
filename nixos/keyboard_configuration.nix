{ pkgs, ... }:

{
  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  services.xserver.displayManager.sessionCommands =
    "${pkgs.xorg.xmodmap}/bin/xmodmap /home/toni/projects/config/xmodmap/xmodmapNormal";

    # services.interception-tools.enable = true;
    # services.interception-tools.udevmonConfig = builtins.readFile ../udevmon/config.yml;
    
    # environment.systemPackages = with pkgs; [
    #   interception-tools
    #   interception-tools-plugins.caps2esc
    # ];
}
