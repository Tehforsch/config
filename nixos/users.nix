{ pkgs, ... }:
{
  users.users.toni = {
    isNormalUser = true;
    description = "toni";
    extraGroups = [ "networkmanager" "wheel" "video" "input" "keyd" "audio" "docker" "wireshark" ];
    shell = pkgs.zsh;

    # Useful for RPI install, for example.
    hashedPassword = "$y$j9T$ZWArZEY8HGeilVKzAiDlJ.$VnMT7HnsgBAKGhXctyFOrlRxPQAFsh.j1Tf1xipjTn.";
  };
}
