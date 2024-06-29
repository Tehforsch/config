{ pkgs, ... }:
{
  # systemd.sleep.extraConfig = ''
  #   IdleActionSec=300s
  #   IdleAction=suspend
  # '';

  services.logind.extraConfig = ''
    IdleActionSec=30s
    IdleAction=suspend
  '';
}
