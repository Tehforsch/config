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
    typst
  ];
  programs.wireshark.enable = true;
}
