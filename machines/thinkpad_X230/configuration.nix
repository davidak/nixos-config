{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../profiles/desktop.nix
    ];

  # Use the GRUB 2 boot loader
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.memtest86.enable = true;
  boot.loader.timeout = 1;
  boot.loader.grub.splashImage = null; # text mode
  boot.loader.grub.device = "/dev/sda";

  /*# disk encryption
  boot.initrd.luks.devices = [
    { name = "rootfs";
      device = "/dev/sda2";
      preLVM = true; }
  ];*/

  # enable power management
  powerManagement.enable = true;

  # enable audio support
  hardware.pulseaudio.enable = true;

  # enable touchpad support
  services.xserver.libinput.enable = true;

  networking = {
    hostName = "X230";
    domain = "lan";

    firewall.enable = false;
  };


  # intel video driver
  services.xserver.videoDrivers = [ "intel" ];
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  # english locales, german keyboard layout
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "de";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Berlin";

  # compatible NixOS release
  system.stateVersion = "17.09";
}
