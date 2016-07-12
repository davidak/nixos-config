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
    device = "/dev/vda";
  };

  networking = {
    # hostname from mnemonic encoding word list
    # http://web.archive.org/web/20091003023412/http://tothink.com/mnemonic/wordlist.txt
    # you could also consider one of these lists https://namingschemes.com/
    hostName = "binary";
    domain = "lan.davidak.de";
    search = [ "${config.networking.domain}" ];

    interfaces = {
      enp0s18.ip4 = [ { address = "10.0.0.23"; prefixLength = 8; } ];
    };

    nameservers = [ "10.0.0.1" "8.8.8.8" ];
    defaultGateway = "10.0.0.1";

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ 80 443 8384 3306 ];
      allowedUDPPorts = [];
    };

    useDHCP = false;
    enableIPv6 = false;
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
    mailutils
    tree
  ];

  # import additional packages
  nixpkgs.config =
  {
    packageOverrides = pkgs: rec
    {
      webseite-aquaregia = pkgs.callPackage ./webseite-aquaregia.nix { };
    };
  };

  # MariaDB
  services.mysql = {
    enable = true;
    initialDatabases = [
      { name = "personen"; schema = ./personen.sql; }
      { name = "piwik"; schema = ./piwik.sql; }
      { name = "satzgenerator"; schema = ./satzgenerator.sql; }
    ];
    dataDir = "/var/mysql" ;
    package = pkgs.mariadb ;
    port = 3306;
  };

  services.mysqlBackup = {
    enable = true;
    databases = [ "satzgenerator" ];
    location = "/var/backup/mysql";
    period = "0 4 * * *";
    singleTransaction = true;
  };

  users.mutableUsers = false;
  users.extraUsers = lib.genAttrs [
    "aww"
    "brennblatt"
    "davidak"
    "gnaclan"
    "meinsack"
    "personen"
    "piwik"
    "satzgenerator"
  ] (user:  {
    isNormalUser = true;
    home = "/var/www/${user}";
    openssh.authorizedKeys.keys = [ pubkey.davidak ];
  });
  system.activationScripts.chmod-www = "chmod 0755 /var/www";
  system.activationScripts.webspace = "for dir in /var/www/*/; do chmod 0755 \${dir}; mkdir -p -m 0755 \${dir}/{web,log}; chown \$(stat -c \"%U:%G\" \${dir}) \${dir}/web; done";

  # Caddy Webserver
  services.caddy = {
    enable = true;
    email = "post@davidak.de";
    config = ''
    import /var/www/*/web/Caddyfile
    '';
  };

  users.users.syncthing = {
    isNormalUser = true;
  };

  services.syncthing = {
    enable = true;
    user = "syncthing";
    dataDir = "/home/syncthing";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";
}
