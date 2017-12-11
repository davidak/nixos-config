{ config, ... }:

{
  # Use the GRUB 2 boot loader
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.memtest86.enable = true;
  boot.loader.timeout = 2;
  boot.loader.grub.splashImage = null; # text mode
}
