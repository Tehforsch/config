{ config, pkgs, inputs, ... }:
{
  services.syncthing = {
    enable = true;
    user = "toni";
    dataDir = "/home/toni/.local/share/syncthing";
    configDir = "/home/toni/.config/syncthing";
    overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    settings = {
      devices = {
        # "pc" = { id = "JSLUTYK-P6GZ22A-22CPQ7V-QWGNYVX-ILA6BB5-N2HWQP5-BIFO6ME-JYBOCQG"; };
        "framework" = { id = "MTF6SQC-HYLYCWI-FBWMX3P-UDKCVUN-XTTG5IA-FJYD4VB-MWPXZGJ-FJAD6QY"; };
        "rpi" = { id = "2ZVVCCZ-J4R4CMX-YIX52JY-U6ONU3O-E5HAED3-PWMR53C-763SVVJ-JJGS3AL"; };
      };
      folders = {
        "synctest1" = {         # Name of folder in Syncthing, also the folder ID
          path = "/home/toni/synctest";    # Which folder to add to Syncthing
          devices = [ "framework" "rpi" ];      # Which devices to share the folder with
        };
      };
    };
  };
}
