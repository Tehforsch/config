{ config, pkgs, inputs, ... }:
let
  makeService = { execStart, description, enable ? true, wantedBy ? [ "default.target" ] }: {
    inherit enable description wantedBy;
    serviceConfig = {
      Type = "simple";
      ExecStart = execStart;
    };
  };
in
{
  systemd.timers.refreshNewsboat = {
    wantedBy = [ "timers.target" ];
    partOf = [ "refreshNewsboat.service" ];
    timerConfig.OnCalendar = "hourly";
  };

  systemd.services.refreshNewsboat = {
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.newsboat}/bin/newsboat -u /home/toni/projects/config/newsboat/urls -C /home/toni/projects/config/newsboat/config -x reload
    '';
  };

  systemd.user.services.journal = makeService {
    description = "journal webserver";
    execStart = "${inputs.journal.packages.x86_64-linux.journal}/bin/journal";
    wantedBy = [ ];
  };

  systemd.user.services.calendarReminder = makeService {
    description = "calendar reminders";
    execStart = "${pkgs.python3}/bin/python /home/toni/projects/config/scripts/calendarReminder.py ${pkgs.khal}/bin/khal ${pkgs.libnotify}/bin/notify-send ${pkgs.vdirsyncer}/bin/vdirsyncer";
  };

  systemd.user.services.flameshot = makeService {
    description = "flameshot";
    execStart = "${pkgs.flameshot}/bin/flameshot";
  };
}
