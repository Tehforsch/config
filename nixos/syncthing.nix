{
  config,
  pkgs,
  ...
}: let
  basicFolders = ["music" "resource" "phone"];
  devices = {
    "pc" = {
      id = "JSLUTYK-P6GZ22A-22CPQ7V-QWGNYVX-ILA6BB5-N2HWQP5-BIFO6ME-JYBOCQG";
      folders = basicFolders ++ ["movies"];
    };
    "framework" = {
      id = "MTF6SQC-HYLYCWI-FBWMX3P-UDKCVUN-XTTG5IA-FJYD4VB-MWPXZGJ-FJAD6QY";
      folders = basicFolders;
    };
    "thinkpad" = {
      id = "ELRICBF-E6JIB37-TXDE65R-4EYY5QY-3SE27FW-YVEVUJT-YSOC5ZP-WEHPUQL";
      folders = basicFolders;
    };
    "rpi" = {
      id = "6FDUQXS-YFYKBVT-KJXLPBF-53DJP4C-TMY7TQO-DQ44RJF-63R6XVI-L7XNAAC";
      folders = basicFolders;
    };
    "phone" = {
      id = "G3YRYKG-CECAOIG-LICKKHB-2J7ZWX4-PSSQTVN-ITFKCPE-N4ABWM6-BP4QEQ2";
      folders = ["phone"];
    };
  };

  folderConfigs = {
    "music" = {
      path = "/home/toni/music";
      versioning = {
        type = "simple";
        params.keep = "2";
      };
    };
    "resource" = {
      path = "/home/toni/resource";
      ignorePerms = false;
      ignorePatterns = ["phone"];
      versioning = {
        type = "simple";
        params.keep = "10";
      };
    };
    "movies" = {
      path = "/home/toni/movies";
    };
    "phone" = {
      path = "/home/toni/resource/phone";
      versioning = {
        type = "simple";
        params.keep = "1";
      };
    };
  };

  # Derive which devices want each folder (excluding current device)
  getDevicesForFolder = folderName:
    builtins.attrNames (pkgs.lib.filterAttrs
      (deviceName: deviceConfig:
        deviceName != hostName && builtins.elem folderName deviceConfig.folders)
      devices);

  hostName = config.networking.hostName;
  thisDevice = devices.${hostName};
  enabledFolders = thisDevice.folders;

  enabledFolderConfigs = builtins.listToAttrs (
    map (folder: {
      name = folder;
      value =
        folderConfigs.${folder}
        // {
          devices = getDevicesForFolder folder;
        };
    })
    enabledFolders
  );

  otherDevices =
    builtins.mapAttrs (name: device: {id = device.id;})
    (builtins.removeAttrs devices [hostName]);
in {
  services.syncthing = {
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
      folders = enabledFolderConfigs;
    };
  };
}
