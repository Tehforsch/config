{ config, pkgs, inputs, ... }: {
  services.syncthing = let
    phone = { 
      "phone" = {
        id = "G3YRYKG-CECAOIG-LICKKHB-2J7ZWX4-PSSQTVN-ITFKCPE-N4ABWM6-BP4QEQ2";
      };
    };
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
    } // phone;
    hostName = config.networking.hostName;
    otherDevices = (pkgs.lib.filterAttrs (k: v: k != hostName) allDevices);
    otherDevicesWithoutPhone = (pkgs.lib.filterAttrs (k: v: (k != hostName && k != "phone")) allDevices);
    othersWithoutPhone = builtins.attrNames otherDevicesWithoutPhone;
    additionalFolders = (if (hostName == "framework" || hostName == "pc") then {
      "movies" = {
        path = "/home/toni/movies";
        devices = if (hostName == "framework") then ["pc"] else ["framework"];
      };
    } else {});
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
          devices = othersWithoutPhone;
          versioning = {
            type = "simple";
            params.keep = "2";
          };
        };
        "resource" = {
          path = "/home/toni/resource";
          devices = othersWithoutPhone;
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
        "from_phone" = {
          devices = ["phone"];
          path = "/home/toni/resource/from_phone";
          type = "receiveonly";
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
        "to_phone" = {
          devices = ["phone"];
          path = "/home/toni/resource/to_phone";
          type = "sendonly";
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
        "keepass" = {
          devices = ["phone"];
          path = "/home/toni/resource/keys/keepass";
          type = "sendonly";
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
      } // additionalFolders;
    };
  };
}
