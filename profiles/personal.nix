{ config, pkgs, lib, ... }:

let
  pubkey = import ../services/pubkey.nix;
in
{
  # install packages
  environment.systemPackages = with pkgs; [
    virtmanager
  ];

  nixpkgs.config = {
    allowUnfreePredicate = (pkg: builtins.elem (builtins.parseDrvName pkg.name).name [ "flashplayer" ]);
    firefox = {
      # constantly broken https://github.com/NixOS/nixpkgs/issues/55657
      #enableAdobeFlash = true;
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
