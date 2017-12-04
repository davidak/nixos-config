{ config, pkgs, ... }:

{
  imports =
    [
      ../services/ssh.nix
      ../services/ntp.nix
      ../services/vim.nix
    ];

  # install basic packages
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
    mtr
    file
    lsof
    lshw
    strace
    zip
    unzip
    rsync
    screen
    tree
    pwgen
    jq
    gitAndTools.gitFull
  ];
}
