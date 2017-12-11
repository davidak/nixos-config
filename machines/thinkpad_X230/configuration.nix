{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../profiles/notebook.nix
      ./x230.nix
      ../../profiles/desktop.nix
    ];

  boot.loader.grub.device = "/dev/sda";

  /*# disk encryption
  boot.initrd.luks.devices = [
    { name = "rootfs";
      device = "/dev/sda2";
      preLVM = true; }
  ];*/

  networking = {
    hostName = "X230";
    domain = "lan";

    firewall.enable = false;
  };

  # compatible NixOS release
  system.stateVersion = "17.09";
}
