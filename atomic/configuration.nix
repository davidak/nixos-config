{ config, pkgs, lib, ... }:

let
  pubkey = import ../service/pubkey.nix;
in
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../service/ssh.nix
      ../service/fail2ban.nix
      ../service/postfix.nix
      ../service/ntp.nix
      ../service/vim.nix
    ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking = rec {
    # hostname from mnemonic encoding word list
    # http://web.archive.org/web/20091003023412/http://tothink.com/mnemonic/wordlist.txt
    # you could also consider one of these lists https://namingschemes.com/
    hostName = "atomic";
    domain = "davidak.de";

    # fix for missing hosts entry https://github.com/NixOS/nixpkgs/issues/1248
    extraHosts = ''
    127.0.0.1 localhost.localdomain localhost
    172.31.1.100 ${hostName}.${domain} ${hostName}

    # The following lines are desirable for IPv6 capable hosts
    ::1     ip6-localhost ip6-loopback
    fe00::0 ip6-localnet
    ff00::0 ip6-mcastprefix
    ff02::1 ip6-allnodes
    ff02::2 ip6-allrouters
    ff02::3 ip6-allhosts
    '';

    interfaces = {
      enp0s3.ip4 = [ { address = "172.31.1.100"; prefixLength = 24; } ];
      enp0s3.ip6 = [ { address = "2a01:04f8:0c17:5c0e::1"; prefixLength = 64; } ];
    };

    nameservers = [ "213.133.99.99" "213.133.98.98" "213.133.100.100" ];
    defaultGateway = "172.31.1.1";
    defaultGateway6 = "fe80::1";

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ 80 443 8384 3306 8081 ];
      allowedUDPPorts = [];
    };

    useDHCP = false;
  };

  time.timeZone = "Europe/Berlin";
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "de";
    defaultLocale = "de_DE.UTF-8";
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    htop
    wget
    rsync
    mailutils
    tree
  ];

  # MariaDB
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.mysqlBackup = {
    enable = true;
    databases = [ "mysql" "piwik" "satzgenerator" ];
    location = "/var/backup/mysql";
    period = "0 4 * * *";
    singleTransaction = true;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";

}
