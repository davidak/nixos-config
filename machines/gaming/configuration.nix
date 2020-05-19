{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../profiles/hardware.nix
      ../../modules/amd
      ../../modules/nvidia
      ../../profiles/desktop.nix
      ../../profiles/personal.nix
      ../../profiles/workstation.nix
      ../../profiles/gaming.nix
      ../../services/boinc.nix
    ];

  boot.loader.grub.device = "/dev/sda";

  # no access time and continuous TRIM for SSD
  fileSystems."/".options = [ "noatime" "discard" ];

  hardware.cpu.intel.updateMicrocode = true;
  # use latest kernel to have best performance
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.gpu.amd.enable = true;
  hardware.gpu.nvidia.enable = false;

  networking = {
    hostName = "gaming";
    domain = "lan";

    firewall.enable = false;
  };

  # compatible NixOS release
  system.stateVersion = "19.03";
}
