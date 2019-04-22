My NixOS Configurations
=======================

NixOS is an innovative GNU/Linux distribution. You can learn more on [nixos.org](https://nixos.org/nixos/about.html).

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

I use the `stable` channel to have a stable system, the `unstable` channel to get the latest version for some packages and `hardware` channel for hardware specific settings.

Add the unstable and hardware channel with this commands:

	nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
	nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
	nix-channel --update

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

## Maintainer

This repository is maintained by [davidak](https://davidak.de/).

## Contributing

When you see ways to improve my configurations, create an [issue](https://github.com/davidak/nixos-config/issues) or [pull request](https://github.com/davidak/nixos-config/pulls).

Consider sharing your configuration as well, so we can learn from each other!

## License

Copyright (C) 2015 [davidak](https://davidak.de/)

Licensed under the [MIT](LICENSE) license to be compatible with [nixpkgs](https://github.com/NixOS/nixpkgs).
