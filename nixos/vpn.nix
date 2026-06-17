{pkgs, ...}: let
  workVpn = pkgs.writeShellScript "work-vpn" ''
    set -euo pipefail

    config_file="/home/toni/resource/keys/vpns/work_vpn.json"

    if [[ ! -f "$config_file" ]]; then
      echo "Config file not found at $config_file" >&2
      exit 1
    fi

    host="$(${pkgs.jq}/bin/jq -r '.work.host' "$config_file")"
    user="$(${pkgs.jq}/bin/jq -r '.work.username' "$config_file")"
    group="$(${pkgs.jq}/bin/jq -r '.work.group' "$config_file")"
    protocol="$(${pkgs.jq}/bin/jq -r '.work.protocol' "$config_file")"
    password="$(${pkgs.jq}/bin/jq -r '.work.password' "$config_file")"

    if [[ "$host" == "null" || "$user" == "null" || -z "$host" || -z "$user" ]]; then
      echo "Missing required fields in $config_file" >&2
      exit 1
    fi

    printf "%s\n" "$password" | exec ${pkgs.openconnect}/bin/openconnect \
      --passwd-on-stdin \
      --protocol="$protocol" \
      --user="$user" \
      --authgroup="$group" \
      --mtu=1380 \
      "$host"
  '';
in {
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        action.id == "org.freedesktop.systemd1.manage-units" &&
        action.lookup("unit") == "work-vpn.service" &&
        ["start", "stop", "restart"].indexOf(action.lookup("verb")) >= 0 &&
        subject.user == "toni"
      ) {
        return polkit.Result.YES;
      }
    });
  '';

  systemd.services.work-vpn = {
    description = "Work VPN";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = workVpn;
      Restart = "no";
    };
  };
}
