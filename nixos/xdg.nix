{pkgs, ...}: {
  # This is super overkill, but I don't want to have to think of
  # actually excecuting this command on a new system.
  environment.systemPackages = with pkgs; [
    xdg-user-dirs
  ];

  systemd.user.services.xdg-setup = {
    description = "Setup XDG user directories and defaults";
    wantedBy = ["default.target"];
    after = ["default.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "xdg-setup" ''
        ${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update
        ${pkgs.xdg-utils}/bin/xdg-mime default org.pwmt.zathura.desktop application/pdf
      '';
    };
  };
}
