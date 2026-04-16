{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Developer stuff
    zsh
    vim
    neovim
    tree-sitter
    git
    jujutsu
    jjui
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
    difftastic
    stylua
    sysz
    hurl # Temporary
  ];

  programs.direnv.enable = true;
}
