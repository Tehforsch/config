{ nixpkgs, ... }:

{
    boot.loader.grub.enable = false;
    boot.loader.generic-extlinux-compatible.enable = true;

    nixpkgs.config.allowUnsupportedSystem = true;
    # nixpkgs.hostPlatform.system = "aarch64-linux";
    # nixpkgs.buildPlatform.system = "x86_64-linux";
}
