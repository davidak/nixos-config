{ config, ... }:

{
  services.resolved.enable = true;
  # workaround for https://github.com/NixOS/nixpkgs/issues/66451
  services.resolved.dnssec = "false";
}
