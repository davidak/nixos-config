{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.useGlamor = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  environment.systemPackages = with pkgs; [
    gnome3.gnome-session
  ];

  # enabled by default
  services.xserver.desktopManager.xterm.enable = false;
}
