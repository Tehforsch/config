{ pkgs, ... }:
{
  users.users.toni = {
    isNormalUser = true;
    description = "toni";
    extraGroups = [ "networkmanager" "wheel" "video" "input" "keyd" "audio" "docker" ];
    shell = pkgs.zsh;
  };
}
