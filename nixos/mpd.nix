{pkgs, ...}: {
  services.mpd = {
    enable = true;
    user = "toni";
    musicDirectory = "/home/toni/music";
    extraConfig = ''
      audio_output {
      type "pipewire"
      name "MPD output"
      }
    '';
    startWhenNeeded =
      true; # systemd feature: only start MPD service upon connection to its socket
  };
  systemd.services.mpd.environment = {
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
    XDG_RUNTIME_DIR = "/run/user/1000"; # User-id 1000 must match above user. MPD will look inside this directory for the PipeWire socket.
  };

  systemd.user.services.mpdas = {
    description = "mpdas last.fm scrobbler";
    wantedBy = ["default.target"];
    serviceConfig = {
      ExecStart = "${pkgs.mpdas}/bin/mpdas -c /home/toni/resource/keys/pw/mpdasrc";
      Type = "simple";
    };
  };
}
