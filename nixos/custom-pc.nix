{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    reaper
    steam
  ];
}
