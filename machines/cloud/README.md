# NixOS configuration for cloud project

>There is no cloud, just other people's computers

The project demonstrates that by having a Nextcloud on a Raspberry Pi.

You can connect to it by wireless lan and download stuff.

**Status**: This is work in progress. Configuration not tested yet...

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
1. Create `/root/nextcloud-password.txt` and put a secure password in it
1. copy `configuration.nix` from this directory to `/etc/nixos/configuration.nix` on the Raspberry Pi
1. apply new configuration with `nixos-rebuild switch`

## Ressources

- https://nixos.wiki/wiki/NixOS_on_ARM#Installation
- https://nixos.wiki/wiki/NixOS_on_ARM/Raspberry_Pi
