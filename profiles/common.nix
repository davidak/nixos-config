{ config, pkgs, ... }:

{
  imports =
    [
      ../services/ssh.nix
      ../services/ntp.nix
      ../services/vim.nix
      ../services/nix.nix
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
    sshfs
    rsync
    screen
    tree
    dfc
    pwgen
    jq
    gitAndTools.gitFull
  ];

  programs.bash.enableCompletion = true;

  # copy the system configuration into nix-store
  system.copySystemConfiguration = true;
}
