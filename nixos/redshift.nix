{
  lib,
  pkgs,
  ...
}: {
  location.provider = "geoclue2";

  services.geoclue2.appConfig.gammastep = {
    isAllowed = true;
    isSystem = true;
  };

  # GeoClue 2.8 requires an explicit IP backend, which the NixOS module does not generate yet.
  environment.etc."geoclue/geoclue.conf".text = lib.mkAfter ''
    [ip]
    enable=true
    method=ichnaea
  '';

  services.redshift = {
    enable = true;
    package = pkgs.gammastep;
    executable = "/bin/gammastep";
    extraOptions = ["-m randr"];
  };
}
