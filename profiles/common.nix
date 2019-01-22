{ config, pkgs, lib, ... }:

let
  unstable = import <nixos-unstable> {};
in
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

  # mount tmpfs on /tmp
  boot.tmpOnTmpfs = lib.mkDefault true;

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
    inotify-tools
    strace
    xz
    lz4
    zip
    unzip
    rsync
    micro
    tealdeer
    screen
    tree
    dfc
    pwgen
    jq
    yq
    gitAndTools.gitFull
  ];

  programs.bash.enableCompletion = true;

  # copy the system configuration into nix-store
  system.copySystemConfiguration = true;
}
