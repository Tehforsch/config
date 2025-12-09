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
    torga = { url = "git+ssh://git@github.com/tehforsch/todo.git"; };
    mpd_rofi = { url = "github:tehforsch/mpd_rofi"; };
    musnix = { url = "github:musnix/musnix"; };
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs@{ self, nixpkgs, ... }: rec {
    nixosConfigurations = let
      basic = [
        ./basic.nix
        ./packages/basic.nix
        ./users.nix
        ./ssh.nix
        ./garbage_collect.nix
        ./xdg.nix
      ];
      desktop_device = basic ++ [
        ./desktop_device.nix
        ./sound.nix
        ./packages/desktop_device.nix
        ./i3.nix
        ./redshift.nix
        ./power_management.nix
        ./syncthing.nix
        ./mpd.nix
        ./oom_killer.nix
      ];
      work = [
        ./work.nix
        ./yubikey.nix
      ];
      personal = [
        ./packages/personal.nix
        ./services.nix
        ./mail.nix
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
            ./mullvad.nix
            ./paperless.nix
            ./android_mounting.nix
          ]
          ++ desktop_device ++ work ++ personal;
      };
      framework = make_system {
        system = "x86_64-linux";
        hostname = "framework";
        modules =
          [
            ./laptop.nix
            ./mullvad.nix
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
          ++ desktop_device ++ work ++ personal;
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
