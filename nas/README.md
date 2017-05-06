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
