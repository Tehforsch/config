{pkgs, ...}: let
  mattermost-desktop-fixed = pkgs.symlinkJoin {
    name = "mattermost-desktop-${pkgs.mattermost-desktop.version}";
    paths = [pkgs.mattermost-desktop];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/mattermost-desktop \
        --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath [pkgs.stdenv.cc.cc.lib]}
    '';
  };
in {
  environment.systemPackages = [mattermost-desktop-fixed pkgs.vpnc];
  nixpkgs.config.permittedInsecurePackages = [
    "electron-28.3.3"
  ];
}
