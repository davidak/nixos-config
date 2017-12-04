NixOS Configuration for a Transmission Seedbox
==============================================

Hardware
--------

The Server is a VM running on KVM, so the disk is named `/dev/vda`.

Usage
-----

Change the boot disk and IPs according to your network.

Create a `credentials.nix` and set the user and passwort for transmission.

	cp credentials.nix.dist credentials.nix
	vim credentials.nix
