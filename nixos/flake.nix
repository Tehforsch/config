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
        ./garbage_collect.nix
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
        ./mpd.nix
      ];
      work = [
        ./work.nix
        ./yubikey.nix
      ];
      personal = [
        ./packages/personal.nix
        ./services.nix
      ];
      make_system = args@{ hostname, system, ... }: (
        nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = { inherit inputs; };
          modules = basic ++ args.modules ++ [
            { networking.hostName = hostname; }
            ./hardware/${hostname}.nix
            ./custom/${hostname}.nix
          ];
        }
      );
    in {
      pc = make_system {
        system = "x86_64-linux";
        hostname = "pc";
        modules =
          [
            inputs.musnix.nixosModules.musnix
            ./music_production.nix
            ./unifiedremote.nix
            ./homebox.nix
            ./mullvad.nix
            ./scanbd.nix
            ./paperless.nix
          ]
          ++ desktop_device ++ work ++ personal;
      };
      framework = make_system {
        system = "x86_64-linux";
        hostname = "framework";
        modules =
          [
            ./laptop.nix
            # ./mullvad.nix
          ]
          ++ desktop_device ++ work ++ personal;
      };
      thinkpad = make_system {
        system = "x86_64-linux";
        hostname = "thinkpad";
        modules =
          [
            ./laptop.nix
          ]
          ++ desktop_device ++ work;
      };
      netcup = make_system {
        system = "x86_64-linux";
        hostname = "netcup";
        modules = [];
      };
      rpi = make_system {
        system = "aarch64-linux";
        hostname = "rpi";
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
