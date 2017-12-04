{ config, pkgs, ... }:

{
  # install packages
  environment.systemPackages = with pkgs; [
    audacity
    pitivi
    kdeApplications.kdenlive
  ];
}
