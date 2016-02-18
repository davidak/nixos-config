My NixOS Configurations
=======================

My workflow with this code is to `rsync` it to the machine and symlink the config.

	imac:code davidak$ rsync -avz nixos root@10.0.0.252:
	[root@default:~]# rm /etc/nixos/configuration.nix
	[root@default:~]# ln -s /root/nixos/web/configuration.nix /etc/nixos/configuration.nix
	[root@default:~]# nixos-rebuild switch

This way i can test a configuration before commit it to the git repository.
