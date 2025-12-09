{ pkgs, ... }:
{
  # This is super overkill, but I don't want to have to think of
  # actually excecuting this command on a new system.
  environment.systemPackages = with pkgs; [
    xdg-user-dirs
  ];

  systemd.user.services.xdg-user-dirs-update = {
    description = "Update XDG user directories";
    wantedBy = [ "default.target" ];
    after = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update";
    };
  };
}
