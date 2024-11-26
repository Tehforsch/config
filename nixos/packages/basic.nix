{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Developer stuff
    zsh
    vim
    git
    delta
    fd
    bat
    eza
    fzf
    silver-searcher # ag
    ripgrep
    unp
    killall
    zip
    unzip
    htop
    gcc
    gnumake
    cmake
    pkg-config
    jq
  ];

  programs.direnv.enable = true;
}
