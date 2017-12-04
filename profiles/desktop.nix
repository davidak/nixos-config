{ config, pkgs, ... }:

let
  pubkey = import ../services/pubkey.nix;
in
{
  imports =
    [
      ./common.nix
    ];

  # install packages
  environment.systemPackages = with pkgs; [
    atom
    borgbackup
    chromium
    firefox
    keepassx-community
    libreoffice
    mediathekview
    simplescreenrecorder
    python35Packages.xkcdpass
    python35Packages.youtube-dl
    remmina
    virtualbox
    gparted
  ];

  virtualisation.docker.enable = true;

  users.extraUsers.davidak = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" ];
    openssh.authorizedKeys.keys = [ pubkey.davidak ];
  };

  services.syncthing = {
    enable = true;
    user = "davidak";
    dataDir = "/home/davidak/.syncthing";
  };
}
