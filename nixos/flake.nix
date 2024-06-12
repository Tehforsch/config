{
  description = "nixos flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    journal = {
      url = "git+ssh://git@github.com/tehforsch/journal.git";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations = {
      framework = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          { networking.hostName = "framework"; }
          ./configuration.nix
          ./keyboard-configuration.nix
          # ./hyprland.nix
          ./i3.nix
          ./hardware-framework.nix
        ];
      };
      pc = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          { networking.hostName = "pc"; }
          ./configuration.nix
          ./keyboard-configuration.nix
          # ./hyprland.nix
          ./i3.nix
          ./hardware-pc.nix
          ./custom-pc.nix
        ];
      };
    };
  };
}
