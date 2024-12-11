{ nixpkgs, ... }:

{
    boot.loader.grub.enable = false;
    boot.loader.generic-extlinux-compatible.enable = true;

    nixpkgs.config.allowUnsupportedSystem = true;

    users.users.toni.initialPassword = "abcdabcd";
}
