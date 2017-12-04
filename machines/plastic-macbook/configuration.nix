{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../profiles/desktop.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # disk encryption
  boot.initrd.luks.devices = [
    { name = "rootfs";
      device = "/dev/sda2";
      preLVM = true; }
  ];

  # control fan of mac computers
  services.mbpfan = {
    enable = true;
    lowTemp = 40;
    highTemp = 60;
    maxTemp = 80;
    minFanSpeed = 1800;
    pollingInterval = 15;
  };

  # enable power management
  powerManagement.enable = true;

  # enable audio support
  hardware.pulseaudio.enable = true;

  # enable touchpad support
  services.xserver.libinput.enable = true;

  networking = {
    hostName = "plastic-macbook";
    domain = "lan";

    firewall.enable = false;
    wireless.enable = true;
    useDHCP = true;
  };

  # enable the X11 windowing system
  services.xserver.enable = true;

  # intel video driver
  services.xserver.videoDrivers = [ "intel" ];
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  # enable Xfce desktop
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # mac keyboard layout
  services.xserver.xkbModel = "apple_laptop";
  services.xserver.xkbVariant = "mac";
  services.xserver.layout = "de";
  # use numpad enter as right alt (lvl3)
  services.xserver.xkbOptions = "eurosign:e,lv3:enter_switch,terminate:ctrl_alt_bksp";

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
