{ pkgs, ... }:
{
  services.pcscd.enable = true;
  environment.systemPackages = with pkgs; [ yubioath-flutter ];
}
