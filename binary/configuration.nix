{ config, pkgs, lib, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../service/fail2ban.nix
      ../service/postfix.nix
      ../service/ntp.nix
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
    hostName = "ip4d152ad6";
    domain = "dynamic.kabel-deutschland.de";
    search = [ "${config.networking.domain}" ];

    interfaces = { 
      eth0.ip4 = [ { address = "10.0.0.23"; prefixLength = 8; } ]; 
    };

    nameservers = [ "10.0.0.1" "8.8.8.8" ];
    defaultGateway = "10.0.0.1";

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [];
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
    vim
    htop
    wget
    mailutils
    tree
  ];

  # MariaDB
  services.mysql = {
    enable = true;
    dataDir = "/var/mysql" ;
    package = pkgs.mariadb ;
    port = 3306;
  };

  services.mysqlBackup = { 
    enable = true;
    databases = [ ];
    location = "/var/backup/mysql";
    period = "0 4 * * *";
    singleTransaction = true;
  };

  users.mutableUsers = false;
  users.extraUsers = lib.genAttrs [
    "aquaregia"
    "aww"
    "brennblatt"
    "davidak"
    "meinsack"
    "piwik"
    "satzgenerator"
  ] (user:  {
    isNormalUser = true;
    home = "/var/www/${user}";
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0gSy7qdULWLSpGuGM6BAoFztX123g/cbW6x3TfzKo0s59y9OrzHrCSTYg3QN9BY1jLRp5DSMjHvsPS1Z/yp3EIJJS/dDso5/noDqOMBLOQgIdCLKipTudngpFDvnCAAg0IQl6iuVRznQvq9Xww65uYyR3OAv4DMvHFQn0qa5G3ZHCoj7I6FATTwGDKPeuqVF2MtdXC1XXx7v7zsar1sBhibUlbWSWhSvw+vhM+Qtj95wkHzI8O93Xy8Vqb5/OoXQDGyA0MnORCLeE8t7EvUi9ukXGz6QMwRX/T1RTLBP+pvrT5UyPtchzgZigbxvegnAy8HRA7I9TlUSFnTVvN6sg6z7n/F09HX1ETBv1qce/uuDc+npfM6Kdykz93ydro1ZfnPabD6rvie972EK5IVsO6n5066vVVhUt9QxDl2CDa0tLBxnGovvV1nmtcjq2AewOX2vj5qD0U256AiiS8tNA0i9GQLW90x6o1/Ih2xaPagfrRmpQjR1ecbEFYxT34Lp5ZuC9x5Nm67RGb4JvvbMrz3qjR5YARKOiryJ5owrN3TUJmYp75xT7QBGkXBwhQJZwwBFhg5rKC5BJIj5x4PGJXrwHHuk6gpbLRbgoT69NmJYIkKZaPSIt+oOzVmgKBM5LTtI4JI8kPs2CHo2FwuYAnP9XAfGoTuB/Ir9ECkFoEQ== davidak" ];
  });
  system.activationScripts.chmod-www = "chmod 0755 /var/www";
  system.activationScripts.webspace = "for dir in /var/www/*; do mkdir -p -m 0755 \${dir}/{web,log}; chown \$(stat -c \"%U:%G\" \${dir}) \${dir}/web; done";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";
  users.users.root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0gSy7qdULWLSpGuGM6BAoFztX123g/cbW6x3TfzKo0s59y9OrzHrCSTYg3QN9BY1jLRp5DSMjHvsPS1Z/yp3EIJJS/dDso5/noDqOMBLOQgIdCLKipTudngpFDvnCAAg0IQl6iuVRznQvq9Xww65uYyR3OAv4DMvHFQn0qa5G3ZHCoj7I6FATTwGDKPeuqVF2MtdXC1XXx7v7zsar1sBhibUlbWSWhSvw+vhM+Qtj95wkHzI8O93Xy8Vqb5/OoXQDGyA0MnORCLeE8t7EvUi9ukXGz6QMwRX/T1RTLBP+pvrT5UyPtchzgZigbxvegnAy8HRA7I9TlUSFnTVvN6sg6z7n/F09HX1ETBv1qce/uuDc+npfM6Kdykz93ydro1ZfnPabD6rvie972EK5IVsO6n5066vVVhUt9QxDl2CDa0tLBxnGovvV1nmtcjq2AewOX2vj5qD0U256AiiS8tNA0i9GQLW90x6o1/Ih2xaPagfrRmpQjR1ecbEFYxT34Lp5ZuC9x5Nm67RGb4JvvbMrz3qjR5YARKOiryJ5owrN3TUJmYp75xT7QBGkXBwhQJZwwBFhg5rKC5BJIj5x4PGJXrwHHuk6gpbLRbgoT69NmJYIkKZaPSIt+oOzVmgKBM5LTtI4JI8kPs2CHo2FwuYAnP9XAfGoTuB/Ir9ECkFoEQ== davidak" ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";
}
