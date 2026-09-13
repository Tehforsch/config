{
  config,
  pkgs,
  ...
}: {
  location =
    if config.networking.hostName == "pc"
    then {
      latitude = 51.0;
      longitude = 10.0;
      provider = "manual";
    }
    else {
      provider = "geoclue2";
    };

  services.redshift = {
    enable = true;
  };
}
