{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
in
{
  # install packages
  environment.systemPackages = with pkgs; [
    # chat
    hexchat
    unstable.dino
    #wire
    # mail
    thunderbird
    gnupg
    gpa
    # rss/atom reader
    liferea
  ];
}
