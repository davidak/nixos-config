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

  hardware.cpu.intel.updateMicrocode = true;

  networking = {
    hostName = "imac";
    domain = "lan";

    firewall.enable = false;
  };

  # TODO: move
  services.syncthing.dataDir = "/home/davidak/.syncthing";

  # compatible NixOS release
  system.stateVersion = "18.09";
}
