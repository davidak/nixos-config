{ config, pkgs, ... }:

{
  # install packages
  environment.systemPackages = with pkgs; [
    # chat
    #wire
    # mail
  ];
}
