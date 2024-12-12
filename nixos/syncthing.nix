{ config, pkgs, inputs, ... }: {
  services.syncthing = let
    allDevices = {
      "pc" = {
        id = "JSLUTYK-P6GZ22A-22CPQ7V-QWGNYVX-ILA6BB5-N2HWQP5-BIFO6ME-JYBOCQG";
      };
      "framework" = {
        id = "MTF6SQC-HYLYCWI-FBWMX3P-UDKCVUN-XTTG5IA-FJYD4VB-MWPXZGJ-FJAD6QY";
      };
      "thinkpad" = {
        id = "ELRICBF-E6JIB37-TXDE65R-4EYY5QY-3SE27FW-YVEVUJT-YSOC5ZP-WEHPUQL";
      };
      "rpi" = {
        id = "6FDUQXS-YFYKBVT-KJXLPBF-53DJP4C-TMY7TQO-DQ44RJF-63R6XVI-L7XNAAC";
      };
    };
    otherDevices =
      (pkgs.lib.filterAttrs (k: v: k != config.networking.hostName) allDevices);
    others = builtins.attrNames otherDevices;
  in {
    enable = true;
    user = "toni";
    dataDir = "/home/toni/.local/share/syncthing";
    configDir = "/home/toni/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    key = "/home/toni/resource/keys/syncthing/${config.networking.hostName}/key.pem";
    cert = "/home/toni/resource/keys/syncthing/${config.networking.hostName}/cert.pem";
    settings = {
      devices = otherDevices;
      folders = {
        "music" = {
          path = "/home/toni/music";
          devices = others;
        };
        "resource" = {
          path = "/home/toni/resource";
          devices = others;
        };
      };
    };
  };
}
