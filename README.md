My NixOS Configurations
=======================

NixOS is an awesome GNU/Linux distribution. You can learn more on [nixos.org](https://nixos.org/nixos/about.html).

In this repository are the configurations of my NixOS machines.

You can find the configurations from other people in the [nixos.wiki](https://nixos.wiki/wiki/Configuration_Collection).

## Usage

My workflow with this code is to `rsync` it to the machine and symlink the system configuration.

	[davidak@X230:~]$ rsync -ah --delete --progress /home/davidak/code/nixos root@10.0.2.48:
	[root@nixos:~]# rm /etc/nixos/configuration.nix
	[root@nixos:~]# ln -s /root/nixos/machines/compaq_dc7800/configuration.nix /etc/nixos/configuration.nix
	[root@nixos:~]# nixos-rebuild switch

This way i can test a change before committing it to the git repository. To update the configuration, just use the first and last command.

For new machines i use the default configuration and extend it as needed.

I use the `stable` channel to have a stable system, the `unstable` channel to get the latest version for some packages and `hardware` channel for hardware specific fixes.

	[root@nixos:~]# nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
	[root@nixos:~]# nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
	[root@nixos:~]# nix-channel --update

(execute as root or with sudo)

References:

- https://nixos.wiki/wiki/FAQ#How_can_I_install_a_package_from_unstable_while_remaining_on_the_stable_channel.3F
- https://github.com/NixOS/nixos-hardware

## Structure

### machines

Here are the `configuration.nix` files for my machines. See the `README` for detailed description.

### modules

My personal NixOS modules.

### packages

My personal Nix packages.

### profiles

Options for specific domains like `server`, `desktop` or `video-production`.

### services

Default service configurations.

## License

Copyright (C) 2015 [davidak](https://davidak.de/)

Licensed under the [MIT](LICENSE) license to be compatible with [nixpkgs](https://github.com/NixOS/nixpkgs).
