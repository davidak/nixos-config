# NixOS Install Image with bcachefs support (experimental)

## Create ISO image

    $ nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=/root/nixos/install-iso-bcachefs/configuration.nix

Or just download ISO here: https://davidak.de/tmp/nixos-17.09.git.226a295-x86_64-linux-with-bcachefs.iso

## Create bootable USB-drive

    $ dd if=result/iso/nixos-*.iso of=/dev/sdb

## Install NixOS on bcachefs root FS

**WIP**

    cfdisk /dev/sda
    mkfs.ext4 -L boot /dev/sda1
    mkfs.bcachefs -L nixos /dev/sda2
    mount -t bcachefs /dev/sda2 /mnt
    mkdir /mnt/boot
    mount /dev/disk/by-label/boot /mnt/boot
    nixos-generate-config --root /mnt
    nano /mnt/etc/nixos/configuration.nix
    nix-channel --update
    nix-env -iA nixos.gitAndTools.gitFull
    git clone https://github.com/davidak/nixpkgs.git
    cd nixpkgs/
    git checkout bcachefs
    NIX_PATH=nixpkgs=/root/nixpkgs/ nixos-install
    history
