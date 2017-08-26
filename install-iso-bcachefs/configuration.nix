{ config, lib, pkgs, modulesPath, ... }:
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
     permitRootLogin = "yes";
     passwordAuthentication = true;
   };
}
