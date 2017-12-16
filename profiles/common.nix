{ config, pkgs, ... }:

{
  imports =
    [
      ../services/grub.nix
      ../services/ssh.nix
      ../services/ntp.nix
      ../services/vim.nix
      ../services/nix.nix
      ../services/localization.nix
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
