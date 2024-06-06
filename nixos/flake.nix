{
  description = "nixos flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations = {
      framework = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { networking.hostName = "framework" }
          ./configuration.nix
          ./hardware-framework.nix
          ./keyboard-configuration.nix
        ];
      };
      pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { networking.hostName = "pc" }
          ./configuration.nix
          ./hardware-pc.nix
          ./keyboard-configuration.nix
        ];
      };
    };
  };
}
