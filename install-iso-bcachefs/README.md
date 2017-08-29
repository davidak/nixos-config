# NixOS Install Image with experimental bcachefs support

## Create ISO image

    $ nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=/root/nixos/install-iso-bcachefs/configuration.nix

Or just download it here: https://github.com/davidak/nixos-config/releases/download/1.0/nixos-17.09.git.1efca7b-x86_64-linux-with-bcachefs.iso

## Create bootable USB-drive

    $ dd if=result/iso/nixos-*.iso of=/dev/sdb

## Install NixOS on bcachefs

### Create `dos` partitions

- 400 MB /boot (set boot flag)
- 1.6 GB SWAP
- 10 GB /

    cfdisk /dev/sda

#### Create filesystems

    mkfs.ext4 -L boot /dev/sda1
    mkswap -L swap /dev/sda2
    mkfs.bcachefs -L nixos /dev/sda3

#### Mount filesystems
    
    mount -t bcachefs /dev/sda2 /mnt
    mkdir /mnt/boot
    mount /dev/disk/by-label/boot /mnt/boot
    swapon /dev/disk/by-label/swap
    
#### Create and edit Config
    
    nixos-generate-config --root /mnt
    nano /mnt/etc/nixos/configuration.nix

I'm not sure if `boot.supportedFilesystems = [ "bcachefs" ];` is needed but i have set it and it works.

#### Install NixOS

    nixos-install
    reboot

(can take more than 1 hour since the kernel is compiled)
