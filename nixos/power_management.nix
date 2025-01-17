{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xautolock
  ];
  services.xserver.xautolock = {
    enable = true;
    locker = "${pkgs.systemd}/bin/systemctl suspend -i";
    time = 15;
  };
  # This disables the default 20min suspend timer
  # even though I don't even have gdm?
  services.xserver.displayManager.gdm.autoSuspend = false;

  systemd.user.timers.restartXautolock = {
    wantedBy = [ "timers.target" ];
    partOf = [ "restartXautolock.service" ];
    timerConfig.OnCalendar = "minutely";
  };
  systemd.user.services.restartXautolock = {
    serviceConfig.Type = "oneshot";
    script = ''
        soundPlaying=$(${pkgs.pulseaudio}/bin/pactl list | grep -c "RUNNING") 
        scpRunning=$(${pkgs.procps}/bin/pgrep scp | wc -l) 
        reaperRunning=$(${pkgs.procps}/bin/pgrep -x reaper | wc -l)
        qbitTorrentRunning=$(${pkgs.procps}/bin/pgrep qbittorrent | wc -l)
        if [[ $soundPlaying -ge 1 || "$scpRunning" -ge 1 || "$reaperRunning" -ge 1 || "$qbitTorrentRunning" -ge 1 ]]; then
            ${pkgs.xautolock}/bin/xautolock -restart
        fi
    '';
  };

}
