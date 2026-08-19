{
  config,
  pkgs,
  inputs,
  ...
}: let
  makeService = {
    execStart,
    description,
    enable ? true,
    wantedBy ? ["default.target"],
  }: {
    inherit enable description wantedBy;
    serviceConfig = {
      Type = "simple";
      ExecStart = execStart;
    };
  };
in {
  systemd.user.timers.syncCalendars = {
    wantedBy = ["timers.target"];
    timerConfig.OnCalendar = "hourly";
  };

  systemd.user.services.syncCalendars = {
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.vdirsyncer}/bin/vdirsyncer discover
      ${pkgs.vdirsyncer}/bin/vdirsyncer sync
    '';
  };

  systemd.user.services.journal = makeService {
    description = "journal webserver";
    execStart = "${inputs.journal.packages.x86_64-linux.default}/bin/journal";
    wantedBy = [];
  };

  systemd.user.services.flameshot = makeService {
    description = "flameshot";
    execStart = "${pkgs.flameshot}/bin/flameshot";
  };
}
