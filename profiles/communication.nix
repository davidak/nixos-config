{ config, pkgs, ... }:

{
  # install packages
  environment.systemPackages = with pkgs; [
    # chat
    hexchat
    #wire
    # mail
    thunderbird
    gnupg
    gpa
  ];
}
