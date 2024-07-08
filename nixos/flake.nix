{
  description = "nixos flake";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    journal = { url = "git+ssh://git@github.com/tehforsch/journal.git"; };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix  = { url = "github:musnix/musnix"; };
  };

  outputs = inputs@{ self, nixpkgs, ... }: rec {
    nixosConfigurations = let
      modules = [
        ./basic.nix
        ./configuration.nix
        ./sound.nix
        ./services.nix
        ./default-packages.nix
        ./keyboard-configuration.nix
        # ./hyprland.nix
        ./i3.nix
        ./redshift.nix
        ./power-management.nix
      ];
      only_work = [
        ./work.nix
        ./yubikey.nix
      ];
      only_personal = [
        ./syncthing.nix
      ];
    in {
      pc = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules =
          [
            { networking.hostName = "pc"; }
            ./hardware-pc.nix
            ./custom-pc.nix 
            inputs.musnix.nixosModules.musnix
          ]
          ++ modules ++ only_work ++ only_personal;
      };
      framework = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules =
          [
            { networking.hostName = "framework"; }
            ./laptop.nix
            ./hardware-framework.nix
            ./custom-framework.nix
          ]
          ++ modules ++ only_personal;
      };
      thinkpad = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules =
          [
            { networking.hostName = "thinkpad"; }
            ./laptop.nix
            ./hardware-thinkpad.nix
            ./custom-thinkpad.nix
          ]
          ++ modules ++ only_work;
      };
      rpi = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules =
          [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            { networking.hostName = "rpi"; } ./basic.nix ./syncthing.nix
            {
              nixpkgs.config.allowUnsupportedSystem = true;
              nixpkgs.hostPlatform.system = "aarch64-linux";
              nixpkgs.buildPlatform.system = "x86_64-linux"; #If you build on x86 other wise changes this.
              # ... extra configs as above
            }
          ];
      };
    };
    images.rpi = nixosConfigurations.rpi.config.system.build.sdImage;
  };
}
