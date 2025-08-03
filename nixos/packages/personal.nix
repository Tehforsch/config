{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ 
    signal-desktop
    newsboat
    mumble
    khal
    vdirsyncer
    taskwarrior
    qpwgraph
    wireshark
    qbittorrent
    steam
  ];
  programs.wireshark.enable = true;
}
