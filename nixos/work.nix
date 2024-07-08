{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ mattermost-desktop ];
  nixpkgs.config.permittedInsecurePackages = [
    "electron-28.3.3"
  ];
}
