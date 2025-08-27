{ nixpkgs, inputs, lib, ... }:

{
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  nixpkgs.config.allowUnsupportedSystem = true;

  # Syncthing did not work without this.
  security.polkit.enable = true;
  networking.networkmanager.enable = true;



  imports = [
    # ...
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];


  hardware = {
    raspberry-pi."4" = {
      fkms-3d.enable = true;
      # This does not seem to work.
      # audio.enable = true; 
      dwc2.enable = true;
      apply-overlays-dtmerge.enable = true;
    };
    deviceTree = {
      enable = true;
      filter = lib.mkForce "*rpi-4-*.dtb";
    };
  };
  boot.kernelParams = [
    "snd_bcm2835.enable_hdmi=1" # needed for CEC?
    "snd_bcm2835.enable_headphones=1"
    "hdmi_ignore_edid_audio=1"
  ];
}
