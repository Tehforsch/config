{ nixpkgs, ... }:

{
    nixpkgs.config.allowUnsupportedSystem = true;
    nixpkgs.hostPlatform.system = "aarch64-linux";
    nixpkgs.buildPlatform.system = "x86_64-linux"; #If you build on x86 other wise changes this.
    # ... extra configs as above
}
