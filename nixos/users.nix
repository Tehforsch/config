{ pkgs, ... }:
{
  users.users.toni = {
    isNormalUser = true;
    description = "toni";
    extraGroups = [ "networkmanager" "wheel" "video" "input" "keyd" "audio" "docker" "wireshark" ];
    shell = pkgs.zsh;
  };
}
