{ config, pkgs, ... }:

{
  # install packages
  environment.systemPackages = with pkgs; [
    audacity
    obs-studio
    # https://github.com/NixOS/nixpkgs/issues/20449
    #pitivi
    # https://github.com/NixOS/nixpkgs/issues/29614
    #kdeApplications.kdenlive
    # too simple, also broken
    #openshot-qt
  ];
}
