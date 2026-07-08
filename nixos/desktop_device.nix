{pkgs, ...}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # To build RPI image
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

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
    nerd-fonts.symbols-only
    source-sans
    source-sans-pro
    roboto
  ];

  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-vpnc
  ];
  programs.nm-applet.enable = true;


  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Oh no
  boot.kernelParams = ["mitigations=off"];


  # This allows me to emulate virtual gamepads for game testing and
  # I think the security considerations are acceptable.
  boot.kernelModules = [ "uinput" ];
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
  '';
}
