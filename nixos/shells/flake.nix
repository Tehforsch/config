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
    rust_stable = pkgs.rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" "rust-analyzer" ];
    };
    rust_nightly = (pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default)).override {
      extensions = [ "rust-src" "rust-analyzer" ];
    };
    rust_oldNightly = (pkgs.rust-bin.nightly."2024-06-10").default.override {
      extensions = [ "rust-src" "rust-analyzer" ];
    };
    rust_wasm = pkgs.rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" "rust-analyzer" ];
      targets = [ "wasm32-unknown-unknown" ];
    };
    mkShellWithAliases = args: let
      originalShellHook = args.shellHook or "";
      customPath = ''export PATH="$PATH:$CONFIG/zsh/direnv_aliases/$(basename $(pwd))"'';
      modifiedShellHook = ''
        export PATH=${customPath}:$PATH
        ${originalShellHook}
      '';
      modifiedArgs = args // {
        shellHook = modifiedShellHook;
      };
      in pkgs.mkShell modifiedArgs;
    makeBasicRustShell = (rustToolChain: mkShellWithAliases {
      buildInputs = with pkgs; [ pkg-config cmake rustToolChain clang ];
    });
    makeScannerShell = (rustToolChain: mkShellWithAliases {
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
        typos
        libclang
      ];
      shellHook = "export LIBCLANG_PATH=${pkgs.libclang.lib}/lib";
    });
  in {
    devShells = with pkgs; {
      rust_stable = makeBasicRustShell rust_stable;
      rust_nightly = makeBasicRustShell rust_nightly;
      rust_wasm = makeBasicRustShell rust_wasm;
      scanner = makeScannerShell rust_stable;
      scannerNightly = makeScannerShell rust_nightly;
      diman = mkShellWithAliases {
        buildInputs = [ pkg-config cmake rust_nightly clang libclang hdf5 mpi ];
        shellHook = "export LIBCLANG_PATH=${pkgs.libclang.lib}/lib";
      };
      molt = mkShellWithAliases {
        buildInputs = [ pkg-config clang rust_stable openssl ];
        shellHook = "export LIBCLANG_PATH=${pkgs.libclang.lib}/lib";
      };
      syn = mkShellWithAliases {
        buildInputs = [ pkg-config clang rust_nightly openssl ];
        shellHook = "export LIBCLANG_PATH=${pkgs.libclang.lib}/lib";
      };
      striputary = mkShellWithAliases {
        buildInputs = [ pkg-config cmake rust_stable clang libclang dbus alsa-lib

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
      subsweep = mkShellWithAliases {
        buildInputs = [ pkg-config cmake rust_oldNightly clang libclang hdf5 mpi ];
        shellHook = "export LIBCLANG_PATH=${pkgs.libclang.lib}/lib";
      };
      bevy = mkShellWithAliases {
        buildInputs = ([
          clang
          lld
        ]);
        nativeBuildInputs = ([
          rust_stable
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
      guitar_practice = mkShellWithAliases {
        nativeBuildInputs = with pkgs; [
          rust_stable
          sqlite
          clang
          libclang 
          prettier
        ];

      };
      dioxus = mkShellWithAliases {
        nativeBuildInputs = with pkgs; [
          rust_wasm
          dioxus-cli
          pkg-config
          gobject-introspection
          nodejs
          clang
          wasm-bindgen-cli
        ];

        buildInputs = with pkgs; [
          at-spi2-atk
          atkmm
          cairo
          gdk-pixbuf
          glib
          gtk3
          xdotool
          harfbuzz
          librsvg
          libsoup_3
          pango
          webkitgtk_4_1
          openssl
        ];
      };
      python = mkShellWithAliases {
        buildInputs = [ (python3.withPackages (p: with p; [ numpy pyyaml ])) ];
      };
      uv = mkShellWithAliases {
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
