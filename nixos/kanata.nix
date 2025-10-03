{ pkgs, lib, ... }:
let
  kanata-wrapper = pkgs.writeShellScript "kanata-wrapper" ''
    #!/usr/bin/env bash
    export PATH="${pkgs.i3}/bin:${pkgs.bash}/bin:$PATH"
    exec ${pkgs.kanata-with-cmd}/bin/kanata --cfg /home/toni/projects/config/kanata/default.kbd
  '';
in
{
  services.kanata = {
    enable = true;
    package = pkgs.kanata-with-cmd;
    keyboards.default = {
        configFile = ../kanata/default.kbd;
    };
  };

  # Override the systemd service to use our wrapper script
  systemd.services.kanata-default = {
    serviceConfig = lib.mkForce {
      User = "root";
      Group = "root";
      SupplementaryGroups = [ "input" "uinput" ];
      ExecStart = "${kanata-wrapper}";
      Restart = "always";
      RestartSec = 1;
    };
  };

  # Useful for debugging every now and then.
  environment.systemPackages = with pkgs; [
    kanata-with-cmd
  ];

  # I feel dirty
  # writes the i3socket to a file so i can use it from the other service
  # which kinda has to run as root.
  systemd.user.services.i3-socket-writer =
    let i3-socket-writer = pkgs.writeShellScript "i3-socket-writer" ''
    ${pkgs.i3}/bin/i3 --get-socketpath > /tmp/i3-ipc.sock
    ''; in
    {
      enable = true;
      description = "i3-socket-writer";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${i3-socket-writer.outPath}";
        Restart = "always";
      };
      path = with pkgs; [
        i3
      ]; 
    };

}
