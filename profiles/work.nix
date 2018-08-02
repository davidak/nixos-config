{ config, pkgs, lib, ... }:

let
  pubkey = import ../services/pubkey.nix;
in
{
  # install packages
  environment.systemPackages = with pkgs; [
  ];

  # container virtualization
  virtualisation.docker.enable = true;

  # hypervisor virtualization
  virtualisation.virtualbox.host.enable = true;

  # use gb ssh key
  users.extraUsers.root.openssh.authorizedKeys.keys = lib.mkDefault [ pubkey.gb ];

  users.extraUsers.davidak = {
    isNormalUser = true;
    extraGroups = lib.mkDefault [ "wheel" "networkmanager" "audio" "video" "docker" ];
    openssh.authorizedKeys.keys = lib.mkDefault [ pubkey.gb ];
  };

  services.syncthing = {
    enable = true;
    user = "davidak";
    dataDir = "/home/davidak/.syncthing";
    openDefaultPorts = true;
  };
}
