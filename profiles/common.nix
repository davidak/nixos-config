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
    tcpdump
    telnet
    whois
    mtr
    siege
    file
    lsof
    strace
    xz
    lz4
    zip
    unzip
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
