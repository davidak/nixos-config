{ config, pkgs, lib, ... }:
{
  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # Use linux kernel for Raspberry Pi 1
  boot.kernelPackages = pkgs.linuxPackages_rpi;

  # Use community maintained binary cache for ARMv6 / ARMv7
  nix.binaryCaches = lib.mkForce [ "http://nixos-arm.dezgeg.me/channel" ];
  nix.binaryCachePublicKeys = [ "nixos-arm.dezgeg.me-1:xBaUKS3n17BZPKeyxL4JfbTqECsT+ysbDJz29kLFRW0=%" ];

  # !!! Needed for the virtual console to work on the RPi 3, as the default of 16M doesn't seem to be enough.
  # If X.org behaves weirdly (I only saw the cursor) then try increasing this to 256M.
  # On a Raspberry Pi 4 with 4 GB, you should either disable this parameter or increase to at least 64M if you want the USB ports to work.
  boot.kernelParams = ["cma=32M"];

  # File systems configuration for using the installer's partition layout
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/NIXOS_BOOT";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  swapDevices = [ { device = "/swapfile"; size = 512; } ];

  # enable wireless lan access point with DHCP
  services.hostapd = {
    enable = true;
    #interface = "";
    hwMode = "g";
    channel = 8;
    ssid = "cloud";
    wpa = false;
  };

  # we need a DNS server that knows the hostname of the nextcloud and is set to the clients of hostapd by DHCP...

  # setup nextcloud
  services.nextcloud = {
    enable = true;
    hostName = "cloud.lan";
    maxUploadSize = "1G";
    config = {
      adminuser = "admin";
      adminpassFile = "/root/nextcloud-password.txt";
    };
  };
}
