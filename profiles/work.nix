{ config, pkgs, lib, ... }:

let
  pubkey = import ../services/pubkey.nix;
in
{
  imports =
  [
    ../users/davidak/work.nix
  ];

  # install packages
  environment.systemPackages = with pkgs; [
    zoom-us
    mattermost
    thunderbird
  ];

  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "zoom-us"
    ];
  };

  # container virtualization
  virtualisation.docker.enable = true;

  # hypervisor virtualization
  virtualisation.virtualbox.host.enable = true;

  # use gb ssh key
  users.extraUsers.root.openssh.authorizedKeys.keys = lib.mkDefault [ pubkey.gb ];
}
