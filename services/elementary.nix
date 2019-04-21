{ config, pkgs, ... }:

{
  # for an elementary OS like experience

  # bamf service needed by plank
  services.bamf.enable = true;

  # install packages
  environment.systemPackages = with pkgs; [
    # select as window decoration theme
    greybird
    # select as theme
    pantheon.elementary-gtk-theme
    # select as icon theme
    elementary-xfce-icon-theme
    pantheon.elementary-terminal
    plank
  ];
}
