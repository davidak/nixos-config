{ config, pkgs, lib, ... }:
{
  imports =
    [
      <home-manager/nixos>
    ];

  users.extraUsers.davidak = {
    isNormalUser = true;
    # TODO: optional if docker.enable ++ docker
    extraGroups = lib.mkDefault [ "wheel" "networkmanager" "audio" "video" "docker" "libvirtd" ];
  };

  services.syncthing = {
    enable = true;
    user = "davidak";
    dataDir = "/home/davidak/.syncthing";
    openDefaultPorts = true;
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  home-manager.users.davidak = { pkgs, ... }: {
    #home.packages = with pkgs; [ httpie ];
    
    programs.bash = {
      enable = true;
      historyControl = [ "ignoredups" "ignorespace" ];
    };

    programs.ssh.enable = true;
  };
}
