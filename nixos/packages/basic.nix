{pkgs, ...}: {
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
    curl
    wget
    lsof
    sd
    difftastic
    stylua
    sysz
    hurl # Temporary
    shellcheck

    # Python
    uv
    ruff
    # python312Packages.python-lsp-server # temporarily didn't work
    (python3.withPackages (ps: [ps.pyyaml ps.telethon])) # I sometimes want a REPL, so having this always there is nice
  ];

  programs.direnv.enable = true;
}
