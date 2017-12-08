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
    wireless = {
      enable = true;
      networks = {
        Altenheim = {
          psk = "ad82651243010c842c7ce24a26271c423e07eb0089836e32df997d0c17510fa2";
        };
      };
    };
    useDHCP = true;
  };

  # enable the X11 windowing system
  services.xserver.enable = true;

  # intel video driver
  services.xserver.videoDrivers = [ "intel" ];
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  # use lightdm login manager
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.default      = "none";
  services.xserver.windowManager.default       = "i3";
  services.xserver.desktopManager.xterm.enable = false;

  # use i3 tiling window manager
  services.xserver.windowManager.i3.enable = true;

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
