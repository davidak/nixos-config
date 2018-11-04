{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../profiles/hardware.nix
      ../../profiles/desktop.nix
      ../../profiles/personal.nix
      ../../profiles/workstation.nix
      ../../profiles/gaming.nix
    ];

  # Use the systemd-boot EFI boot loader
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # workaround for https://github.com/NixOS/nixpkgs/issues/36802
  boot.kernelPackages = pkgs.linuxPackages_4_9;
  hardware.cpu.intel.updateMicrocode = true;
  # needs https://github.com/NixOS/nixpkgs/pull/49722
  services.xserver.videoDrivers = [ "ati_unfree" ];
  hardware.opengl.driSupport32Bit = true;
  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "imac";
    domain = "lan";

    firewall.enable = false;
  };

  # compatible NixOS release
  system.stateVersion = "18.09";
}
