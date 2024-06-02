{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "toni";
  home.homeDirectory = "/home/toni";

  nixpkgs.config.allowUnfree = true;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
      kitty
      firefox
      git
      thunderbird
      emacs
      openssh
      rustup
      fd
      zsh
      eza
      fzf
      bat
      telegram-desktop
      rofi
      gcc
      light
      oath-toolkit
      silver-searcher
      qbittorrent
      ripgrep
      openvpn
      syncthing
      unp
      steam
      redshift
      pavucontrol
      pulseaudio # for pactl etc? even though i have pipewire
  ];

  home.file = {
    # ".screenrc".source = dotfiles/screenrc;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

}
