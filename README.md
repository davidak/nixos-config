My NixOS Configurations
=======================

My workflow with this code is to `rsync` it to the machine and symlink the config.

	imac:code davidak$ rsync -ahz --progress nixos root@10.0.0.252:
	[root@nixos:~]# rm /etc/nixos/configuration.nix
	[root@nixos:~]# ln -s /root/nixos/web/configuration.nix /etc/nixos/configuration.nix
	[root@nixos:~]# nixos-rebuild switch

This way i can test a configuration before committing it to the git repository.
