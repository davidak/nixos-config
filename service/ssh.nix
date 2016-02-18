{ config, pkgs, ... }:

let
  pubkey = import ./pubkey.nix;
in
{
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";
  users.extraUsers.root.openssh.authorizedKeys.keys = [ pubkey.davidak ];
}
