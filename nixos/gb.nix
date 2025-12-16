{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
  ];

  users.users.gvm = {
    isNormalUser = true;
    description = "gvm";
    extraGroups = ["networkmanager" "wheel" "input" "docker" "gvm"];
    shell = pkgs.zsh;
  };

  users.groups.gvm = {};
}
