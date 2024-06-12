{
  description = "Rust stable dev shell";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        devShells.rust_stable = with pkgs; mkShell {
          buildInputs = [
            pkg-config
            rust-bin.beta.latest.default
            cmake
          ];
        };
        devShells.rust_nightly = with pkgs; mkShell {
          buildInputs = [
            pkg-config
            (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default))
            cmake
          ];
        };
      }
    );
}
