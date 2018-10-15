{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
in
{
  # for an elementary OS like experience

  # bamf service needed by plank
  services.bamf.enable = true;

  # greybird/default.nix:20 has an unfree license (‘unknown’)
  nixpkgs.config.allowUnfree = true;

  # install packages
  environment.systemPackages = with pkgs; [
    # select as window decoration theme
    greybird
    # select as theme
    elementary-gtk-theme
    # select as icon theme
    elementary-xfce-icon-theme
    pantheon.pantheon-terminal
    plank
  ];
}
