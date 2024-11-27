{
  description = "nixos flake";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    journal = { url = "github:tehforsch/journal"; };
  };

  outputs = inputs@{ self, nixpkgs, ... }: rec {
    nixosConfigurations = let
      basic = [
        ./basic.nix
        ./packages/basic.nix
        ./users.nix
        ./keyboard_configuration.nix
        ./ssh.nix
      ];
      desktop_device = basic ++ [
        ./desktop_device.nix
        ./sound.nix
        ./packages/desktop_device.nix
        # ./hyprland.nix
        ./i3.nix
        ./redshift.nix
        ./power_management.nix
      ];
      work = [
        ./work.nix
        ./yubikey.nix
      ];
      personal = [
        ./packages/personal.nix
        ./syncthing.nix
        ./services.nix
      ];
      make_system = args@{ hostname, ... }: (
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = basic ++ args.modules ++ [
            { networking.hostName = hostname; }
            ./hardware/${hostname}.nix
            ./custom/${hostname}.nix
          ];
        }
      );
    in {
      pc = make_system {
        hostname = "pc";
        modules =
          [
            ./unifiedremote.nix
            ./mullvad.nix
          ]
          ++ desktop_device ++ work ++ personal;
      };
      framework = make_system {
        hostname = "framework";
        modules =
          [
            ./laptop.nix
          ]
          ++ desktop_device ++ work ++ personal;
      };
      thinkpad = make_system {
        hostname = "thinkpad";
        modules =
          [
            ./laptop.nix
          ]
          ++ desktop_device ++ work;
      };
      netcup = make_system {
        hostname = "netcup";
        modules = [];
      };
      rpi = make_system {
        hostname = "rpi";
        modules =
          [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            ./syncthing.nix
          ];
      };
    };
    images.rpi = nixosConfigurations.rpi.config.system.build.sdImage;
  };
}
