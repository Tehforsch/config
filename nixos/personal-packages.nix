{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ 
    telegram-desktop
    signal-desktop
    newsboat
    taskwarrior
    mumble
  ];
}
