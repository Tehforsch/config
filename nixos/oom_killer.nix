{ config, lib, pkgs, ... }:

{
  # Disable systemd-oomd to avoid conflicts
  systemd.oomd.enable = false;
  
  # Enable earlyoom for better memory management
  services.earlyoom.enable = true;
}