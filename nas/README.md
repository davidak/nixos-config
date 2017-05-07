NixOS NAS
=========

Why buy an overpriced [NAS](https://en.wikipedia.org/wiki/Network-attached_storage), install [FreeNAS](https://freenas.org/) or [Rockstor](http://rockstor.com/) when you can setup [Samba](https://www.samba.org/) with few lines of [NixOS](http://nixos.org/) config?

Project is **WORK IN PROGRESS**!

Features
--------

- SMB Shares
- Monitoring storage devices via [S.M.A.R.T.](https://en.wikipedia.org/wiki/S.M.A.R.T.) with email notification
- Monitoring with [netdata](https://my-netdata.io/) and [vnStat](http://humdi.net/vnstat/)

Install
-------

```
# boot NixOS Live CD
# start ssh daemon
systemctl start sshd
# set root password
passwd
# get ip
ip a
# connect via ssh
ssh root@10.0.2.48
# create partition on system disk
fdisk /dev/sda
n
p
<ENTER>
<ENTER>
<ENTER>
p
w
# create btrfs filesystem
mkfs.btrfs /dev/sda1 -L root
# mount filesystem
mount /dev/disk/by-label/root /mnt
services.openssh.enable = true;
services.openssh.permitRootLogin = "yes";
# enable configuration
nixos-rebuild switch


# generate basic NixOS config
nixos-generate-config --root /mnt
# change device for bootloader and enable ssh
nano /mnt/etc/nixos/configuration.nix
boot.loader.grub.device = "/dev/sda";
services.openssh.enable = true;
services.openssh.permitRootLogin = "yes";
# install NixOS
nix-channel --update
nixos-install
reboot


# sync config to maschine
imac:code davidak$ rsync -ahz --progress nixos root@10.0.2.82:
# symlink config
[root@nixos:~]# ln -s /root/nixos/nas/configuration.nix /etc/nixos/configuration.nix
# configure system
[root@nixos:~]# nixos-rebuild switch
reboot
# set password
[root@nas:~]# passwd davidak
# create smb user, set password
smbpasswd -a davidak
```
