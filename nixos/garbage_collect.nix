{ config, pkgs, inputs, ... }:
{
    nix.gc = {
        automatic = true;
        dates = "weekly";
        persistent = true;
        options = "--delete-older-than 30d";
    };
    nix.settings.auto-optimise-store = true;
}

