{ config, pkgs, inputs, ... }:
{

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.KbdInteractiveAuthentication = true;
  };
  users.users.toni.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBljzjzlraj+tA8veF0DHj2+beJUvCQAGgOx2btJm9tF toni"
  ];
}
