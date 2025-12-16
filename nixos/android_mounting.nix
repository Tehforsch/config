{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    simple-mtpfs
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="users"
  '';
}
