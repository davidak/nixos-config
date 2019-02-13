{ config, pkgs, ... }:

{
  # install packages
  environment.systemPackages = with pkgs; [
    audacity
    obs-studio
    pitivi
    kdeApplications.kdenlive
  ];
}
