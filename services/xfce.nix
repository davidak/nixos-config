{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  services.xserver.desktopManager.xterm.enable = false;

  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [ networkmanagerapplet greybird ];
}
