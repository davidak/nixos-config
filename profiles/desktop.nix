{ config, pkgs, ... }:

let
  pubkey = import ../services/pubkey.nix;
in
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
    mediathekview
    gnome-mpv
    pavucontrol
    simplescreenrecorder
    cheese
    nautilus
    sushi
    eog
    evince
    python35Packages.xkcdpass
    python35Packages.youtube-dl
    asciinema
    remmina
    virtmanager
    dconf-editor
    gparted
    screenfetch
    twemoji-color-font
  ];

  nixpkgs.config = {
    firefox = {
      enableAdobeFlash = true;
    };
  };

  # container virtualization
  virtualisation.docker.enable = true;

  # hypervisor virtualization
  virtualisation.libvirtd = {
    enable = true;
    qemuPackage = pkgs.qemu_kvm;
  };

  users.extraUsers.davidak = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" "libvirtd" ];
    openssh.authorizedKeys.keys = [ pubkey.davidak ];
  };

  services.syncthing = {
    enable = true;
    user = "davidak";
    dataDir = "/home/davidak/.syncthing";
  };
}
