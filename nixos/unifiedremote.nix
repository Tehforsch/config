{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ urserver ];

  networking.firewall = {
    allowedTCPPorts = [ 9510 9512 ];
    allowedUDPPorts = [ 9511 9512 ];
  };

  systemd.user.services.urserver = {
    description = ''
      Unified Remote server.
    '';
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "network.target" ];
    # These are needed by the remotes
    path= with pkgs; [ mpc-cli pulseaudio ];
    serviceConfig = {
      Type = "forking";
      ExecStart = ''
        ${pkgs.urserver}/bin/urserver --daemon --remotes=/home/toni/projects/config/unifiedremote/
      '';
      ExecStop = ''
        ${pkgs.procps}/bin/pkill urserver
      '';
      RestartSec = 3;
      Restart = "on-failure";
    };
  };
}
