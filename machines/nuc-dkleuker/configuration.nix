{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../profiles/hardware.nix
      ../../profiles/desktop.nix
      ../../profiles/work.nix
    ];

  # Use the systemd-boot EFI boot loader
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # no access time and continuous TRIM for SSD
  fileSystems."/".options = [ "noatime" "discard" ];
  fileSystems."/boot".options = [ "noatime" "discard" ];

  swapDevices = [
    { device = "/var/swapfile"; size = 8192; }
  ];

  networking = {
    hostName = "nuc-dkleuker";
    domain = "devel.greenbone.net";
    search = [ "devel.greenbone.net" "office.greenbone.net" ];

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };

  # compatible NixOS release
  system.stateVersion = "19.03";
}
