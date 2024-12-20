{ config, pkgs, inputs, ... }:
{
  systemd.user.services.journal = {
    enable = true;
    description = "journal webserver";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${inputs.journal.packages.x86_64-linux.journal}/bin/journal";
    };
  };

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

  systemd.user.services.calendarReminder = {
    enable = true;
    description = "calendar reminders";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.python3}/bin/python /home/toni/projects/config/scripts/calendarReminder.py ${pkgs.khal}/bin/khal ${pkgs.libnotify}/bin/notify-send ${pkgs.vdirsyncer}/bin/vdirsyncer";
    };
  };
}
