{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ 
    signal-desktop
    newsboat
    mumble
    khal
    vdirsyncer
    taskwarrior
    steam
    qpwgraph
    wireshark
  ];
  programs.wireshark.enable = true;
}
