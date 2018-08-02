{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
in
{
  # for an elementary OS like experience

  # install packages
  environment.systemPackages = with pkgs; [
    # select as window decoration theme
    greybird
    # select as theme
    elementary-gtk-theme
    # select as icon theme
    elementary-xfce-icon-theme
    pantheon.pantheon-terminal
    unstable.plank
  ];
}
