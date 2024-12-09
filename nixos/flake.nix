{
  description = "nixos flake";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    journal = { url = "github:tehforsch/journal"; };
    moody = { url = "git+ssh://git@github.com/tehforsch/moodyTelegramBot.git"; };
    personalbot = { url = "git+ssh://git@github.com/tehforsch/personalbot.git"; };
    musnix = { url = "github:musnix/musnix"; };
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
        ./syncthing.nix
      ];
      work = [
        ./work.nix
        ./yubikey.nix
      ];
      personal = [
        ./packages/personal.nix
        ./services.nix
      ];
      make_system = args@{ hostname, ... }: (
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = basic ++ args.modules ++ [
            { networking.hostName = hostname; }
            ./hardware/${hostname}.nix
            ./custom/${hostname}.nix
          ];
        }
      );
      make_x86_system = {hostname, modules}: make_system {
        hostname = hostname;
        modules = modules;
        system = "x86_64-linux";
      };
    in {
      pc = make_x86_system {
        hostname = "pc";
        modules =
          [
            inputs.musnix.nixosModules.musnix
            ./music_production.nix
            ./unifiedremote.nix
            ./mullvad.nix
          ]
          ++ desktop_device ++ work ++ personal;
      };
      framework = make_x86_system {
        hostname = "framework";
        modules =
          [
            ./laptop.nix
          ]
          ++ desktop_device ++ work ++ personal;
      };
      thinkpad = make_x86_system {
        hostname = "thinkpad";
        modules =
          [
            ./laptop.nix
          ]
          ++ desktop_device ++ work;
      };
      netcup = make_x86_system {
        hostname = "netcup";
        modules = [];
      };
      rpi = make_system {
        hostname = "rpi";
        system = "aarch64-linux";
        modules =
          [
            ./syncthing.nix
          ];
      };
    };
    images = {
        rpi = (nixosConfigurations.rpi.extendModules {
            modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            ];
        }).config.system.build.sdImage;
    };
  };
}
