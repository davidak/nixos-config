{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
in
{
  # for an elementary OS like experience

  # use new bamf package from unstable; needed by plank
  #services.bamf.enable = true;
  services.dbus.packages = [ unstable.bamf ];
  systemd.packages = [ unstable.bamf ];

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
