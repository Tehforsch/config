{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    signal-desktop
    mumble
    vdirsyncer
    qpwgraph
    wireshark
    qbittorrent
    typst
  ];
  programs.wireshark.enable = true;
}
