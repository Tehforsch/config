{ pkgs, ... }:
{
  services.kanata.enable = true;
  services.kanata.keyboards.default = {
    configFile = ../kanata/default.kbd;
  };
}
