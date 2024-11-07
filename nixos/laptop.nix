{ pkgs, ... }:
{
  programs.light = {
    enable = true;
  };
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
    ];
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 50;
    };
  };

  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
    telegram-desktop
    bluetuith
  ];

  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      Enable = "Source,Sink,Media,Socket";
      Name = "Hello";
      ControllerMode = "dual";
      FastConnectable = "true";
      Experimental = "true";
      KernelExperimental = "true";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
