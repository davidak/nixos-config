{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    htop
    wget
    curl
    telnet
    whois
    file
    unzip
    rsync
    screen
    mailutils
    tree
    gitAndTools.gitFull
  ];
}
