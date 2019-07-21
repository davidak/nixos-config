{ config, pkgs, ... }:

{
  # install packages
  environment.systemPackages = with pkgs; [
    audacity
    obs-studio
    # wait for 1.0 release; use flatpak RC until then
    #pitivi
    kdeApplications.kdenlive
  ];
}
