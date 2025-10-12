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
    wget
    lsof
    sd
  ];

  programs.direnv.enable = true;
}
