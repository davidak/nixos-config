{ config, pkgs, ... }:

{
  # install packages for software development
  environment.systemPackages = with pkgs; [
    pipenv
  ];
}
