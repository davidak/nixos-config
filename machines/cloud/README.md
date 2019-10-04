# NixOS configuration for cloud project

>There is no cloud, just other people's computers

The project demonstrates that by having a Nextcloud on a Raspberry Pi.

You can connect to it by wireless lan and download stuff.

**Status**: There are several issues which lead to not being able to build this configuration.

- https://github.com/NixOS/nixpkgs/issues/70411
- https://github.com/NixOS/nixpkgs/issues/51798
- https://github.com/NixOS/nix/issues/2393

I try to use [NextCloudPi](https://ownyourbits.com/nextcloudpi/) instead of NixOS.

## Hardware

We use a Raspberry Pi 1 Model B+ with 1 CPU core and 512 MB RAM.

## Software

- NixOS Linux
- hostapd
- Nextcloud

## Installation

1. Download community maintained armv6l image from http://nixos-arm.dezgeg.me/installer
1. Copy image to SD card with `sudo dd if=sd-image-armv6l-linux.img of=/dev/sdX`
1. boot Raspberry Pi from SD card
1. set secure root password with `passwd`
1. start SSH server with `systemctl start sshd`
1. set nixos stable channel with `nix-channel --add https://nixos.org/channels/nixos-19.03 nixos`
1. update channel with `nix-channel --update`
1. Create `/root/nextcloud-password.txt` and put a secure password in it
1. copy `configuration.nix` from this directory to `/etc/nixos/configuration.nix` on the Raspberry Pi
1. first rebuild with `nixos-rebuild switch --fast --option binary-caches http://nixos-arm.dezgeg.me/channel --option binary-cache-public-keys nixos-arm.dezgeg.me-1:xBaUKS3n17BZPKeyxL4JfbTqECsT+ysbDJz29kLFRW0=%`
1. apply later configuration changes with `nixos-rebuild switch`

## Ressources

- https://nixos.wiki/wiki/NixOS_on_ARM#Installation
- https://nixos.wiki/wiki/NixOS_on_ARM/Raspberry_Pi
