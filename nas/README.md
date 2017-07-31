NixOS NAS
=========

Why buy an overpriced [NAS](https://en.wikipedia.org/wiki/Network-attached_storage), install [FreeNAS](https://freenas.org/) or [Rockstor](http://rockstor.com/) when you can setup [Samba](https://www.samba.org/) with few lines of [NixOS](http://nixos.org/) config?

Project is **WORK IN PROGRESS**!

Features
--------

- SMB Shares
- Monitoring storage devices via [S.M.A.R.T.](https://en.wikipedia.org/wiki/S.M.A.R.T.) with email notification
- Monitoring with [netdata](https://my-netdata.io/) and [vnStat](http://humdi.net/vnstat/)

Tipps and Tricks
----------------

- enable [AHCI](https://en.wikipedia.org/wiki/Advanced_Host_Controller_Interface) in your BIOS to have hot swap

Install
-------

Follow the generic install manual at [nixos.org](http://nixos.org/nixos/manual/index.html#ch-installation) or on [my website](https://davidak.de/nixos-installation/) in german.

Then follow this instructions to setup your NAS:

```
imac:code davidak$ rsync -ahz --progress nixos root@nas.lan:

[root@nixos:~]# rm /etc/nixos/configuration.nix
[root@nixos:~]# ln -s /root/nixos/nas/configuration.nix /etc/nixos/configuration.nix
[root@nixos:~]# nixos-rebuild switch

[root@NAS:~]# mkfs.btrfs -d raid1 -m raid1 -L data /dev/sdb /dev/sdc
mkdir /data
mount /dev/disk/by-label/data /data
# include mountpoint in hardware config.
nixos-generate-config

btrfs subvolume create /data/media
btrfs subvolume create /data/archiv
btrfs subvolume create /data/backup
btrfs subvolume create /data/upload
btrfs subvolume create /data/snapshots

mkdir /data/snapshots/{archiv,backup,media,upload}
chown davidak:users -R /data/
chmod 700 /data/*
chmod -R 777 /data/upload/

smbpasswd -a davidak
passwd davidak
```

Maintenance
-----------

### show filesystem usage

    [root@nas:~]# btrfs fi usage -T /data/
    Overall:
        Device size:		  14.55TiB
        Device allocated:		   9.47TiB
        Device unallocated:		   5.09TiB
        Device missing:		     0.00B
        Used:			   9.22TiB
        Free (estimated):		   2.67TiB	(min: 2.67TiB)
        Data ratio:			      2.00
        Metadata ratio:		      2.00
        Global reserve:		 512.00MiB	(used: 0.00B)

                Data    Metadata System
    Id Path     RAID1   RAID1    RAID1     Unallocated
    -- -------- ------- -------- --------- -----------
     1 /dev/sdb 4.72TiB 10.00GiB   8.00MiB     2.54TiB
     2 /dev/sdc 4.72TiB 10.00GiB   8.00MiB     2.54TiB
    -- -------- ------- -------- --------- -----------
       Total    4.72TiB 10.00GiB   8.00MiB     5.09TiB
       Used     4.60TiB  7.73GiB 688.00KiB

### show drive errors

    [root@nas:~]# btrfs device stats /data
    [/dev/sdb].write_io_errs   0
    [/dev/sdb].read_io_errs    0
    [/dev/sdb].flush_io_errs   0
    [/dev/sdb].corruption_errs 0
    [/dev/sdb].generation_errs 0
    [/dev/sdc].write_io_errs   0
    [/dev/sdc].read_io_errs    0
    [/dev/sdc].flush_io_errs   0
    [/dev/sdc].corruption_errs 0
    [/dev/sdc].generation_errs 0

### create snapshot

    [root@nixos:~]# btrfs subvolume snapshot -r /data/upload /data/snapshots/upload/$(date -I)
    Create a readonly snapshot of '/data/upload' in '/data/snapshots/upload/2017-07-31'

or for every subvolume at once

    [root@nas:~]# for i in archiv backup media upload; do btrfs subvolume snapshot -r /data/$i /data/snapshots/$i/$(date -I); done
    Create a readonly snapshot of '/data/archiv' in '/data/snapshots/archiv/2017-07-31'
    Create a readonly snapshot of '/data/backup' in '/data/snapshots/backup/2017-07-31'
    Create a readonly snapshot of '/data/media' in '/data/snapshots/media/2017-07-31'
    Create a readonly snapshot of '/data/upload' in '/data/snapshots/upload/2017-07-31'

Resources
---------

- [Centos 7 with BTRFS and snapshots](https://www.mopar4life.com/btrfs-centos-samba/)
- [The perfect Btrfs setup for a server](https://seravo.fi/2016/perfect-btrfs-setup-for-a-server)
- [Using RAID with btrfs and recovering from broken disks](https://seravo.fi/2015/using-raid-btrfs-recovering-broken-disks)
- [Arch Linux Wiki: Btrfs](https://wiki.archlinux.org/index.php/Btrfs)
