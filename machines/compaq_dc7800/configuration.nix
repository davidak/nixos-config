{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../profiles/hardware.nix
      ../../profiles/desktop.nix
      ../../profiles/workstation.nix
    ];

  boot.loader.grub.device = "/dev/sda";
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/bb4ef5af-9645-4b5c-85ad-04c21b9c91e6";
      preLVM = true;
      allowDiscards = true;
    }
  ];

  # no access time and continuous TRIM for SSD
  fileSystems."/".options = [ "noatime" "discard" ];
  fileSystems."/boot".options = [ "noatime" "discard" ];

  hardware.cpu.intel.updateMicrocode = true;
  services.xserver.videoDrivers = [ "radeon" ];

  networking = {
    hostName = "dc7800";
    domain = "lan";

    firewall.enable = false;
  };

  # compatible NixOS release
  system.stateVersion = "17.09";
}
