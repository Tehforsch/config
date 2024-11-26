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
      only_work = [
        ./work.nix
        ./yubikey.nix
      ];
      only_personal = [
        ./packages/personal.nix
        ./syncthing.nix
        ./services.nix
      ];
    in {
      pc = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules =
          [
            { networking.hostName = "pc"; }
            ./hardware/pc.nix
            ./custom/pc.nix 
            ./unifiedremote.nix
            ./mullvad.nix
          ]
          ++ desktop_device ++ only_work ++ only_personal;
      };
      framework = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules =
          [
            { networking.hostName = "framework"; }
            ./laptop.nix
            ./hardware/framework.nix
            ./custom/framework.nix
          ]
          ++ desktop_device ++ only_personal ++ only_work;
      };
      thinkpad = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules =
          [
            { networking.hostName = "thinkpad"; }
            ./laptop.nix
            ./hardware/thinkpad.nix
            ./custom/thinkpad.nix
          ]
          ++ desktop_device ++ only_work;
      };
      netcup = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules =
          basic ++ [
            { networking.hostName = "netcup"; }
            ./ssh.nix
            ./packages/desktop_device.nix
            ./keyboard_configuration.nix
            ./hardware/netcup.nix
            ./custom/netcup.nix
          ];
      };
      rpi = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules =
          basic ++ [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            { networking.hostName = "rpi"; } ./syncthing.nix
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
