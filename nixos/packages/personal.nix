{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ 
    signal-desktop
    newsboat
    mumble
    khal
    vdirsyncer
    qpwgraph
    wireshark
    qbittorrent
  ];
  programs.wireshark.enable = true;
}
