{ config, pkgs, ... }:

{
  # for hardware / bare metal systems

  # install packages
  environment.systemPackages = with pkgs; [
    lshw
    usbutils
    pciutils
  ];
}
