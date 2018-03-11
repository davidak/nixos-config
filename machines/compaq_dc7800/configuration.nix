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
      device = "/dev/disk/by-uuid/abd7e9a8-2f15-4ada-a2a7-66161c1994f2";
      preLVM = true;
      allowDiscards = true;
    }
  ];

  # no access time and continuous TRIM for SSD
  fileSystems."/".options = [ "noatime" "discard" ];
  fileSystems."/boot".options = [ "noatime" "discard" ];

  hardware.cpu.intel.updateMicrocode = true;
  #services.xserver.videoDrivers = [ "radeon" ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.driSupport32Bit = true;
  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "dc7800";
    domain = "lan";

    firewall.enable = false;
  };

  # compatible NixOS release
  system.stateVersion = "18.03";
}
