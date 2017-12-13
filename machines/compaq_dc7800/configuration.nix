{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../profiles/desktop.nix
    ];

  boot.loader.grub.device = "/dev/sda";

  hardware.cpu.intel.updateMicrocode = true;

  # broken https://github.com/NixOS/nixpkgs/issues/32623
  #services.xserver.videoDrivers = [ "displaylink" ];
  #nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "dc7800";
    domain = "lan";

    firewall.enable = false;
  };

  # compatible NixOS release
  system.stateVersion = "17.09";
}
