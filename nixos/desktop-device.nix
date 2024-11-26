{ pkgs, ... }:
{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "toni";

  fonts.packages = with pkgs; [
    jetbrains-mono
    dejavu_fonts
    noto-fonts
    hack-font
    inconsolata
    font-awesome
    barlow
  ];

  virtualisation = {
    docker.enable = true;
  };

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;
  programs.openvpn3.enable = true;

  services.emacs = {
    enable = true;
    defaultEditor = true;
  };
}
