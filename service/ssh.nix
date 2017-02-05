{ config, pkgs, ... }:

let
  pubkey = import ./pubkey.nix;
in
{
  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;
  };
  users.extraUsers.root.openssh.authorizedKeys.keys = [ pubkey.davidak ];
}
