{ config, pkgs, ... }:

{
  # enable power management
  powerManagement.enable = true;

  # enable touchpad support
  services.xserver.libinput.enable = true;
}
