{ config, lib, ... }:

{
  # Use the GRUB 2 boot loader
  boot.loader.grub.enable = lib.mkDefault true;
  boot.loader.grub.version = 2;
  boot.loader.grub.memtest86.enable = true;
  boot.loader.timeout = 2;
}
