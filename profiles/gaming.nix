{ config, pkgs, ... }:

{
  # required for steam https://nixos.wiki/wiki/Steam
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
  nixpkgs.config.allowUnfree = true;

  # install packages
  environment.systemPackages = with pkgs; [
    steam
    steam-run
    playonlinux
  ];
}
