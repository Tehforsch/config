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
    steam
  ];
  programs.wireshark.enable = true;
}
