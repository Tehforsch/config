{
  description = "nixos flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations = {
      toniframework = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hardware-framework.nix
          ./keyboard-configuration.nix
        ];
      };
    };
  };
}
