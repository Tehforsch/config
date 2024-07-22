{ pkgs, ... }:
{
  services.xserver.xautolock = {
    enable = true;
    locker = "${pkgs.systemd}/bin/systemctl suspend";
    nowlocker = "${pkgs.systemd}/bin/systemctl suspend";
    time = 1000;
  };
}
