{ config, pkgs, ... }:

{
  # for an elementary OS like experience

  # install packages
  environment.systemPackages = with pkgs; [
    greybird
    #elementary-gtk-theme
    #elementary-xfce-icon-theme
    pantheon.pantheon-terminal
  ];
}
