{ config, pkgs, lib, ... }:

{
  imports =
  [
    ../users/davidak/personal.nix
  ];
  
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
}
