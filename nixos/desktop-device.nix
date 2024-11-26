{ pkgs, ... }:
{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # We need this in order to be able to build images for the rasperry pi
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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
    # podman = {
    #   enable = true;
    #   # Create a `docker` alias for podman, to use it as a drop-in replacement
    #   dockerCompat = true;
    #   # Required for containers under podman-compose to be able to talk to each other.
    #   defaultNetwork.settings.dns_enabled = true;
    # };
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
