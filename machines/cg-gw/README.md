NixOS Configuration for a VPN Gateway
=====================================

Hardware
--------

The Server is a VM running on KVM, so the disk is named `/dev/vda`.

Usage
-----

Change the boot disk and IPs according to your network.

Create the VPN credentials in this Files:

- /root/.vpn/ca.crt
- /root/.vpn/client.crt
- /root/.vpn/client.key
