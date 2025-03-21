{
  description = "Dev shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    overlays = [ (import rust-overlay) ];
    pkgs = import nixpkgs { inherit system overlays; };
    stable = pkgs.rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" "rust-analyzer" ];
    };
    nightly = (pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default)).override {
      extensions = [ "rust-src" "rust-analyzer" ];
    };
    oldNightly = (pkgs.rust-bin.nightly."2024-06-10").default.override {
      extensions = [ "rust-src" "rust-analyzer" ];
    };
    makeScannerShell = (rustToolChain: pkgs.mkShell {
        packages = [ pkgs.clang pkgs.mold-wrapped ];
        nativeBuildInputs = with pkgs.buildPackages; [
          rustToolChain
          file
          libpcap
          hiredis
          cmake
          libnet
          curl
          redis
          pkg-config
          zlib
          cmake
          glib
          json-glib
          gnutls
          clang
        ];
    });
  in {
    devShells = with pkgs; {
      rust_stable = mkShell {
        buildInputs = [ pkg-config cmake stable clang ];
      };
      rust_nightly = mkShell {
        buildInputs = [ pkg-config nightly cmake clang ];
      };
      scanner = makeScannerShell stable;
      scannerNightly = makeScannerShell nightly;
      diman = mkShell {
        buildInputs = [ pkg-config cmake nightly clang libclang hdf5 mpi ];
        shellHook = "export LIBCLANG_PATH=${pkgs.libclang.lib}/lib";
      };
      striputary = mkShell {
        buildInputs = [ pkg-config cmake stable clang libclang dbus alsa-lib

          # If on x11
          xorg.libX11
          xorg.libX11
          xorg.libXcursor
          xorg.libXi
          xorg.libXrandr
          libxkbcommon
          fontconfig

                      ];
        shellHook = ''
          export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath [
            alsa-lib
            udev
            vulkan-loader
            xorg.libX11
            xorg.libXcursor
            xorg.libXi
            xorg.libXrandr
            libxkbcommon
            fontconfig
          ]}"
        '';
      };
      subsweep = mkShell {
        buildInputs = [ pkg-config cmake oldNightly clang libclang hdf5 mpi ];
        shellHook = "export LIBCLANG_PATH=${pkgs.libclang.lib}/lib";
      };
      bevy = mkShell {
        buildInputs = ([
          clang
          lld
        ]);
        nativeBuildInputs = ([
          stable
          # Bevy
          pkg-config
          alsa-lib
          vulkan-tools
          vulkan-headers
          vulkan-loader
          vulkan-validation-layers
          udev
          # If on x11
          xorg.libX11
          xorg.libX11
          xorg.libXcursor
          xorg.libXi
          xorg.libXrandr
          libxkbcommon
          # If on wayland
          # libxkbcommon
          # wayland
        ]);
        shellHook = ''
          export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath [
            alsa-lib
            udev
            vulkan-loader
            libxkbcommon
          ]}"
        '';
      };
      python = mkShell {
        buildInputs = [ (python3.withPackages (p: with p; [ numpy pyyaml ])) ];
      };
      uv = mkShell {
        nativeBuildInputs = ([
          uv
          ruff
        ]);
        shellHook = ''
          export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath [
            pkgs.libxcrypt-legacy
          ]}"
        '';
      };
    };
  });
}
