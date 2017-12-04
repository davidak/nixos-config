NixOS Configuration for a Transmission Seedbox
==============================================

Hardware
--------

The Server is a VM running on KVM, so the disk is named `/dev/vda`.

Usage
-----

Change the boot disk and IPs according to your network.

Create a `secrets.nix` and set the user and passwort for transmission.

```
[root@atomic:~]# cp nixos-config/machines/atomic/secrets.nix.dist secrets.nix
[root@atomic:~]# vim secrets.nix
```
