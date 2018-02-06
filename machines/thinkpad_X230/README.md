NixOS Desktop on Lenovo Thinkpad X230
=====================================

The notebook will use [coreboot](https://www.coreboot.org/) as BIOS/UEFI replacement.

## Features

- Xfce desktop

## Configuration

You need the nixos-hardware channel:

    nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
    nix-channel --update nixos-hardware

(execute as root or with sudo)
