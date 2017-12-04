{ config, pkgs, ... }:

{
  # install packages
  environment.systemPackages = with pkgs; [
    gimp
    darktable
  ];
}
