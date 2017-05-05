NixOS NAS
=========

Why should you buy an overpriced NAS or install a NAS distribution like [FreeNAS](https://freenas.org/) or [Rockstor](http://rockstor.com/) when you can setup Samba with few lines of code in NixOS?

Projekt still **WORK IN PROGRESS**!

Features
--------

- SMB Shares
- Monitoring with [netdata](https://my-netdata.io/) and [vnstat](http://humdi.net/vnstat/)

Install
-------

```

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
