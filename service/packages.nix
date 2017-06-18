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
    # disable while broken https://github.com/NixOS/nixpkgs/issues/26682
    #mailutils
    tree
    jq
    gitAndTools.gitFull
  ];
}
