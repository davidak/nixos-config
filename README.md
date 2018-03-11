My NixOS Configurations
=======================

NixOS is an awesome GNU/Linux distribution. You can learn more on [it's website](https://nixos.org/nixos/about.html).

In this repository are the configurations of my NixOS machines.

You can find the configurations from other people on https://nixos.wiki/wiki/Configuration_Collection

## Usage

My workflow with this code is to `rsync` it to the machine and symlink the system configuration.

	[davidak@X230:~]$ rsync -ah --delete --progress /home/davidak/code/nixos root@10.0.2.48:
	[root@nixos:~]# rm /etc/nixos/configuration.nix
	[root@nixos:~]# ln -s /root/nixos/machines/compaq_dc7800/configuration.nix /etc/nixos/configuration.nix
	[root@nixos:~]# nixos-rebuild switch

This way i can test a change before committing it to the git repository.

For new machines i use the default configuration and extend it as needed.

## Structure

### machines

Here are the `configuration.nix` files for my machines. See the `README` for detailed description.

### modules

My private NixOS modules.

### packages

My private Nix packages.

### profiles

Options for specific domains like `server`, `desktop` or `video-production`.

### services

Default service configurations.
