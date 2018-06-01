{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  # enabled by default
  services.xserver.desktopManager.xterm.enable = false;
}
