{ pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [ 
    fw-ectool
  ];

  # Allow fw-ectool commands without password for power button LED control
  security.sudo.extraRules = [
    {
      users = [ "toni" ];
      commands = [
        {
          command = "${pkgs.fw-ectool}/bin/ectool led power white";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.fw-ectool}/bin/ectool led power off";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
