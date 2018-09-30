{ config, pkgs, ... }:

let
  # unstable = import <nixos-unstable> {};
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  # required for steam https://nixos.wiki/wiki/Steam
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
  nixpkgs.config.allowUnfree = true;

  # install packages
  environment.systemPackages = with pkgs; [
    unstable.steam
    unstable.steam-run
    playonlinux
  ];
}
