{
  description = "Dev shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      overlays = [(import rust-overlay)];
      pkgs = import nixpkgs {inherit system overlays;};
      rust_stable = pkgs.rust-bin.stable.latest.default.override {
        extensions = ["rust-src" "rust-analyzer" "llvm-tools"];
      };
      rust_nightly = (pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default)).override {
        extensions = ["rust-src" "rust-analyzer" "llvm-tools"];
      };
      rust_oldNightly = (pkgs.rust-bin.nightly."2024-06-10").default.override {
        extensions = ["rust-src" "rust-analyzer"];
      };
      rust_wasm = pkgs.rust-bin.stable.latest.default.override {
        extensions = ["rust-src" "rust-analyzer" "llvm-tools"];
        targets = ["wasm32-unknown-unknown"];
      };
      rust_embedded = pkgs.rust-bin.stable.latest.default.override {
        extensions = ["rust-src" "rust-analyzer"];
        # targets = ["riscv32i-unknown-none-elf"];
        targets = ["riscv32imc-unknown-none-elf"];
      };
      tracy_x11 = (pkgs.tracy.override {withWayland = false;}).overrideAttrs (old: {
        buildInputs =
          old.buildInputs
          ++ (with pkgs; [
            libglvnd
            libx11
            libxcursor
            libxext
            libxi
            libxinerama
            libxrandr
          ]);
      });
      mkShellWithAliases = args: let
        originalShellHook = args.shellHook or "";
        customPath = ''export PATH="$PATH:$CONFIG/zsh/direnv_aliases/$(basename $(pwd))"'';
        modifiedShellHook = ''
          export PATH=${customPath}:$PATH
          ${originalShellHook}
        '';
        modifiedArgs =
          args
          // {
            shellHook = modifiedShellHook;
          };
      in
        pkgs.mkShell modifiedArgs;
      makeBasicRustShell = rustToolChain:
        mkShellWithAliases {
          buildInputs = with pkgs; [pkg-config cmake rustToolChain clang cargo-tarpaulin];
        };
      makeScannerShell = rustToolChain:
        mkShellWithAliases {
          packages = with pkgs; [llvmPackages_19.clang-tools llvmPackages_19.clang mold podman  cargo-tarpaulin];
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
            llvmPackages_19.clang
            typos
            llvmPackages_19.libclang
            net-snmp
            capnproto
            lychee
          ];
          shellHook = "export LIBCLANG_PATH=${pkgs.llvmPackages_19.libclang.lib}/lib";
        };
    in {
      devShells = with pkgs; {
        rust_stable = makeBasicRustShell rust_stable;
        rust_nightly = makeBasicRustShell rust_nightly;
        rust_wasm = makeBasicRustShell rust_wasm;
        scanner = makeScannerShell rust_stable;
        scannerNightly = makeScannerShell rust_nightly;
        diman = mkShellWithAliases {
          buildInputs = [pkg-config cmake rust_nightly clang libclang hdf5 mpi];
          shellHook = "export LIBCLANG_PATH=${pkgs.libclang.lib}/lib";
        };
        molt = mkShellWithAliases {
          buildInputs = [pkg-config clang rust_stable openssl];
          shellHook = "export LIBCLANG_PATH=${pkgs.libclang.lib}/lib";
        };
        syn = mkShellWithAliases {
          buildInputs = [pkg-config clang rust_nightly openssl];
          shellHook = "export LIBCLANG_PATH=${pkgs.libclang.lib}/lib";
        };
        torga = mkShellWithAliases {
          buildInputs = [rust_nightly clang];
        };
        striputary = mkShellWithAliases {
          buildInputs = [
            pkg-config
            cmake
            rust_stable
            clang
            libclang
            dbus
            alsa-lib

            # If on x11
            libX11
            libx11
            libxcursor
            libxi
            libxrandr
            libxkbcommon
            fontconfig
          ];
          shellHook = ''
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath [
              alsa-lib
              udev
              vulkan-loader
              libx11
              libxcursor
              libxi
              libxrandr
              libxkbcommon
              fontconfig
            ]}"
          '';
        };
        subsweep = mkShellWithAliases {
          buildInputs = [pkg-config cmake rust_oldNightly clang libclang hdf5 mpi];
          shellHook = "export LIBCLANG_PATH=${pkgs.libclang.lib}/lib";
        };
        website = mkShellWithAliases {
          buildInputs = [hugo];
        };
        bevy = mkShellWithAliases rec {
          nativeBuildInputs = [
            grcov
            clang
            pkg-config
            rust_wasm
            trunk
            rustup # for cross
            cargo-about
            tracy_x11
          ];
          buildInputs = [
            wayland
            pkg-config
            alsa-lib
            vulkan-tools
            vulkan-headers
            vulkan-loader
            vulkan-validation-layers
            udev
            libglvnd
            # If on x11
            libx11
            libx11
            libxcursor
            libxext
            libxi
            libxinerama
            libxrandr
            libxkbcommon
            (python3.withPackages (p: with p; [pyyaml]))
          ];

          LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
        };
        guitar_practice = mkShellWithAliases {
          nativeBuildInputs = with pkgs; [
            rust_stable
            sqlite
            clang
            libclang
            prettier
            (python3.withPackages (p: with p; [numpy matplotlib pyyaml]))
          ];
        };
        embedded_c = mkShellWithAliases {
          buildInputs = [
            pkgs.platformio
            pkgs.platformio-core
          ];
        };
        embedded_rust = mkShellWithAliases {
          buildInputs = [
            rust_embedded
            pkgs.espflash
            pkgs.pkg-config
            pkgs.libudev-zero
            pkgs.libclang
            pkgs.clang
          ];

          shellHook = ''
            export LIBCLANG_PATH=${pkgs.libclang.lib}/lib
            export CARGO_HOME="$PWD/.cargo-home"
            mkdir -p $CARGO_HOME
          '';
          nativeBuildInputs = with pkgs.buildPackages; [
            cmake
            pkg-config
            cmake
            glib
            clang
          ];
        };
        python = mkShellWithAliases {
          buildInputs = [(python3.withPackages (p: with p; [numpy pyyaml]))];
        };
        uv = mkShellWithAliases {
          nativeBuildInputs = [
            uv
            ruff
          ];
          shellHook = ''
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath [
              pkgs.libxcrypt-legacy
            ]}"
          '';
        };
      };
    });
}
