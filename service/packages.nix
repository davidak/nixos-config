{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    htop
    iotop
    wget
    curl
    tcpdump
    telnet
    whois
    iperf
    file
    lsof
    strace
    unzip
    rsync
    screen
    mailutils
    tree
    jq
    gitAndTools.gitFull
  ];
}
