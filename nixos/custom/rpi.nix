{ inputs, ... }:

{
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  nixpkgs.config.allowUnsupportedSystem = true;

  # Syncthing did not work without this.
  security.polkit.enable = true;

  systemd.services.personalbot = {
    enable = true;
    description = "personalbot";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${inputs.personalbot.packages.aarch64-linux.default}/bin/python ${inputs.personalbot.packages.aarch64-linux.default}/lib/python3.12/site-packages/main.py";
      Restart = "on-failure";
      User = "toni";
    };
  };

  # systemd.user.services.moody = {
  #   enable = true;
  #   description = "moody";
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = "${inputs.moody.packages.aarch64-linux.default}/bin/python ${inputs.moody.packages.aarch64-linux.default}/lib/python3.12/site-packages/main.py";
  #   };
  # };
}
