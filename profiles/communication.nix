{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
in
{
  # install packages
  environment.systemPackages = with pkgs; [
    # irc
    hexchat
    # jabber
    unstable.dino
    gajim
    # matrix
    unstable.fractal
    # other messangers
    signal-desktop
    #wire-desktop
    # mastodon
    # broken https://github.com/NixOS/nixpkgs/issues/63089
    #unstable.tootle
    # mail
    #thunderbird
    #gnupg
    #gpa
    # rss/atom reader
    #liferea
  ];
}
