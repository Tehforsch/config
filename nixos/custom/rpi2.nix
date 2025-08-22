{ nixpkgs, ... }:

{
    boot.loader.grub.enable = false;
    boot.loader.generic-extlinux-compatible.enable = true;

    nixpkgs.config.allowUnsupportedSystem = true;

    # Syncthing did not work without this.
    security.polkit.enable = true;
}
