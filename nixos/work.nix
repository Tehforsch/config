{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ mattermost-desktop vpnc ];
  nixpkgs.config.permittedInsecurePackages = [
    "electron-28.3.3"
  ];
}
