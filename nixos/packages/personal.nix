{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ 
    signal-desktop
    newsboat
    mumble
    khal
    vdirsyncer
    taskwarrior2
    qpwgraph
    wireshark
    qbittorrent
  ];
  programs.wireshark.enable = true;
}
