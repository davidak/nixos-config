{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
in
{
  # required for steam https://nixos.wiki/wiki/Steam
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
  # required for steam hardware detection
  hardware.steam-hardware.enable = true;
  # don't work :/ https://github.com/NixOS/nixpkgs/issues/55678
  #nixpkgs.config.allowUnfreePredicate = (pkg: builtins.elem (builtins.parseDrvName pkg.name).name [ "steam" ]);
  nixpkgs.config.allowUnfree = true;

  # install packages
  environment.systemPackages = with pkgs; [
    steam
    steam-run
    #playonlinux
    mumble

    # games
    #crawl
    #multimc
    gnome3.gnome-mahjongg
  ];
}
