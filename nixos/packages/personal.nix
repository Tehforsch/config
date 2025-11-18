{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ 
    signal-desktop
    mumble
    khal
    vdirsyncer
    qpwgraph
    wireshark
    qbittorrent
  ];
  programs.wireshark.enable = true;
}
