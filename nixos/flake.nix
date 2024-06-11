{
  description = "nixos flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    journal = {
      url = "git+ssh://git@github.com/tehforsch/journal.git";
    };
  };

  outputs = inputs@{ self, nixpkgs, journal, ... }: {
    nixosConfigurations = {
      framework = nixpkgs.lib.nixosSystem {
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
        specialArgs = { inherit journal; };
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
