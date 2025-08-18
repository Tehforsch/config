{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    swayidle
    wlr-randr # For wayland display management
  ];
  
  # This disables the default 20min suspend timer
  # even though I don't even have gdm?
  services.displayManager.gdm.autoSuspend = false;

  # Wayland-compatible power management with swayidle
  systemd.user.services.swayidle-power-mgmt = {
    wantedBy = [ "sway-session.target" ];
    partOf = [ "sway-session.target" ];
    after = [ "sway-session.target" ];
    description = "Idle manager for Wayland - power management";
    
    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      RestartSec = "1";
      ExecStart = "${pkgs.swayidle}/bin/swayidle -w timeout 900 '${pkgs.systemd}/bin/systemctl suspend'";
    };
    
    environment = {
      WAYLAND_DISPLAY = "wayland-1";
      XDG_RUNTIME_DIR = "%t";
    };
  };

  # Timer to check if we should disable power management
  systemd.user.timers.check-power-management = {
    wantedBy = [ "timers.target" ];
    partOf = [ "check-power-management.service" ];
    timerConfig.OnCalendar = "minutely";
  };
  
  systemd.user.services.check-power-management = {
    serviceConfig.Type = "oneshot";
    script = ''
        soundPlaying=$(${pkgs.pulseaudio}/bin/pactl list | grep "RUNNING" | wc -l) 
        scpRunning=$(${pkgs.procps}/bin/pgrep scp | wc -l) 
        reaperRunning=$(${pkgs.procps}/bin/pgrep -x reaper | wc -l)
        qbitTorrentRunning=$(${pkgs.procps}/bin/pgrep qbittorrent | wc -l)
        if [ ! -f /home/toni/.local/state/keep_on ]; then
            keepOnFileExists=0
        else
            keepOnFileExists=1
        fi
        
        if [[ $soundPlaying -ge 1 || "$scpRunning" -ge 1 || "$reaperRunning" -ge 1 || "$qbitTorrentRunning" -ge 1 || $keepOnFileExists -ge 1 ]]; then
            ${pkgs.systemd}/bin/systemctl --user restart swayidle-power-mgmt
        fi
    '';
  };

}
