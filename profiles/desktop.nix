{ config, pkgs, ... }:

{
  imports =
    [
      ./common.nix
      #../services/xfce.nix
      #../services/gnome.nix
      #../services/elementary.nix
      ../services/avahi-client.nix
    ];

  # boot splash instead of log messages
  boot.plymouth.enable = true;

  # use elementarys pantheon desktop environment
  services.xserver.enable = true;
  services.xserver.useGlamor = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.pantheon.enable = true;

  # enabled by default
  services.xserver.desktopManager.xterm.enable = false;

  # enable audio support
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # enable flatpak support
  services.flatpak.enable = true;

  # enable fwupd, a DBus service that allows applications to update firmware
  # broken https://github.com/NixOS/nixpkgs/issues/48425
  #services.fwupd.enable = true;

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
    todo-txt-cli
    python3Packages.xkcdpass
    python3Packages.youtube-dl
    asciinema
    remmina
    dconf-editor
    gparted
    neofetch
    twemoji-color-font
    appimage-run
  ];
}
