{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../profiles/hardware.nix
      ../../profiles/notebook.nix
      ../../profiles/desktop.nix
      ../../profiles/work.nix
      ../../profiles/communication.nix
    ];

  # Use the systemd-boot EFI boot loader
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/b13d00fa-c3b1-4519-b483-f731028724d0";
      preLVM = true;
      allowDiscards = true;
    }
  ];

  # no access time and continuous TRIM for SSD
  fileSystems."/".options = [ "noatime" "discard" ];
  fileSystems."/boot".options = [ "noatime" "discard" ];

  networking = {
    hostName = "ethmoid";
    domain = "devel.greenbone.net";

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };

  nixpkgs.overlays = [
  (self: super:
  {
    gvm-tools = super.callPackage ../../packages/gvm-tools { };
  }
  )];

  # Packages
  environment.systemPackages = with pkgs; [ gvm-tools ];

  # compatible NixOS release
  system.stateVersion = "18.03";
}
