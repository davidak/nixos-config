{ config, pkgs, ... }:

{
  imports =
    [
      ./common.nix
      ../services/fail2ban.nix
      ../services/postfix.nix
    ];
}
