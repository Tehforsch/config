{ pkgs, ... }:
{
  # Enable mbsync systemd user service
  systemd.user.services.mbsync = {
    description = "Mailbox synchronization service";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.isync}/bin/mbsync -a";
    };
  };

  # Timer for automatic syncing every 15 minutes
  systemd.user.timers.mbsync = {
    description = "Timer for mailbox synchronization";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2m";
      OnUnitActiveSec = "15m";
      Unit = "mbsync.service";
    };
  };
}