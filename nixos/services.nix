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

  systemd.user.timers.syncCalendars = {
    wantedBy = [ "timers.target" ];
    partOf = [ "syncCalendars.service" ];
    timerConfig.OnCalendar = "*/15:00";
  };

  systemd.user.services.syncCalendars = {
    serviceConfig.Type = "oneshot";
    script = ''
      yes | ${pkgs.vdirsyncer}/bin/vdirsyncer discover
      ${pkgs.vdirsyncer}/bin/vdirsyncer sync
    '';
  };

  systemd.user.timers.calendarReminder = {
    wantedBy = [ "timers.target" ];
    partOf = [ "calendarReminder.service" ];
    timerConfig.OnCalendar = "minutely";
  };

  systemd.user.services.journal = makeService {
    description = "journal webserver";
    execStart = "${inputs.journal.packages.x86_64-linux.default}/bin/journal";
    wantedBy = [ ];
  };

  systemd.user.services.calendarReminder = {
    enable = true;
    description = "calendar reminders";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.python3}/bin/python /home/toni/projects/config/scripts/calendarReminder.py ${pkgs.khal}/bin/khal ${pkgs.libnotify}/bin/notify-send";
      Restart = "always";
      RestartSec = "10";
    };
  };

  systemd.user.services.flameshot = makeService {
    description = "flameshot";
    execStart = "${pkgs.flameshot}/bin/flameshot";
  };
}
