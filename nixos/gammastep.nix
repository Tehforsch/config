{ pkgs, ... }: {
  systemd.user.services.gammastep =
    {
      enable = true;
      description = "gammastep";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.gammastep}/bin/gammastep -l 49.494:8.650";
        Restart = "always";
      };
      environment = {
        WAYLAND_DISPLAY = "wayland-1";
      };
      path = with pkgs; [
        gammastep
      ]; 
    };
}
