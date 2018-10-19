{ config, pkgs, lib, ... }:

let
  pubkey = import ../services/pubkey.nix;
in
{
  # install packages
  environment.systemPackages = with pkgs; [
    mediathekview
    virtmanager
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
    extraGroups = lib.mkDefault [ "wheel" "networkmanager" "audio" "video" "docker" "libvirtd" ];
    openssh.authorizedKeys.keys = lib.mkDefault [ pubkey.davidak ];
  };

  services.syncthing = {
    enable = true;
    user = "davidak";
    dataDir = "/home/davidak/.syncthing";
    openDefaultPorts = true;
  };
}
