{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    htop
    iotop
    iftop
    wget
    curl
    netcat-gnu
    tcpdump
    telnet
    whois
    iperf
    file
    lsof
    lshw
    strace
    zip
    unzip
    rsync
    screen
    mailutils
    tree
    pwgen
    jq
    gitAndTools.gitFull
  ];
}
