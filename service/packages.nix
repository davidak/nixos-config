{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    busybox
    htop
    wget
    rsync
    screen
    mailutils
    tree
    gitAndTools.gitFull
  ];
}
