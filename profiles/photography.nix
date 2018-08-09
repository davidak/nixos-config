{ config, pkgs, ... }:

{
  # install packages
  environment.systemPackages = with pkgs; [
    darktable
  ];
}
