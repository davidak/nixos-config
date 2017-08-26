# build with:
# $ nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=/root/nixos/install-iso-bcachefs/configuration.nix
# $ dd if=result/iso/nixos-*.iso of=/dev/sdb

{ config, lib, pkgs, modulesPath, ... }:

let
  pubkey = import service/pubkey.nix;
in
{
   imports = [
     <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
   ];

   boot = {
     kernelParams = [ "copytoram=1" ];
     supportedFilesystems = [ "bcachefs" ];
   };

   networking.firewall.enable = false;
   services.openssh = {
     enable = true;
     startWhenNeeded = true;
   };
   users.extraUsers.root.openssh.authorizedKeys.keys = [ pubkey.davidak ];
}
