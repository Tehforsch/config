{ pkgs, ... }:
{
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1min
  '';
}
