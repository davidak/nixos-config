{ config, pkgs, ... }:

{
  imports =
    [
      ./common.nix
      #../services/xfce.nix
      ../services/gnome.nix
      ../services/elementary.nix
      ../services/avahi-client.nix
    ];

  # boot splash instead of log messages
  boot.plymouth.enable = true;

  # enable audio support
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # install packages
  environment.systemPackages = with pkgs; with gnome3; [
    atom
    ghex
    meld
    restic
    chromium
    firefox
    keepassx-community
    libreoffice
    gnome-mpv
    pavucontrol
    simplescreenrecorder
    cheese
    nautilus
    sushi
    eog
    evince
    gimp
    python3Packages.xkcdpass
    python3Packages.youtube-dl
    asciinema
    remmina
    dconf-editor
    gparted
    screenfetch
    twemoji-color-font
  ];
}
