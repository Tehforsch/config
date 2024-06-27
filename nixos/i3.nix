{ config, pkgs, ... }: {
  services.xserver = {
    enable = true;

    desktopManager = { xterm.enable = false; };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ i3status i3lock ];
    };

    xkb.layout = "de";
    xkb.variant = "nodeadkeys";
  };
  services.displayManager = { defaultSession = "none+i3"; };

  environment.systemPackages = with pkgs; [ rofi i3wsr ];

  # This can probably be done much easier but I couldnt figure out how to
  # and it was a nice way to explore some of nix's capabilities
  systemd.user.services.i3wsr =
    let i3wsr-starter = pkgs.writeShellScript "i3wsr-starter" ''
      I3SOCK=$(${pkgs.i3}/bin/i3 --get-socketpath) ${pkgs.i3wsr}/bin/i3wsr
    ''; in
    {
      enable = true;
      description = "i3wsr";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${i3wsr-starter.outPath}";
        Restart = "always";
      };
      path = with pkgs; [
        i3
        i3wsr-starter
      ]; 
    };

}
