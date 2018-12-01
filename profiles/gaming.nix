{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
in
{
  # required for steam https://nixos.wiki/wiki/Steam
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
  # TODO: allow specific app
  #nixpkgs.config.allowUnfree = true;

  # install packages
  environment.systemPackages = with pkgs; [
    steam
    steam-run
    playonlinux
    unstable.mumble

    # games
    assaultcube
    crawl
  ];
}
