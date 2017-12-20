{ config, pkgs, ... }:

{
imports =
  [
    ./video-production.nix
    ./photography.nix
  ];

  # install packages
  environment.systemPackages = with pkgs; [
    # chat
    #wire
    # mail
  ];
}
