{ config, pkgs, lib, ... }:

let
  pubkey = import ../service/pubkey.nix;
in
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../service/packages.nix
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
      enp0s3.ip6 = [
        { address = "2a01:04f8:0c17:5c0e::1"; prefixLength = 64; }
        { address = "2a01:04f8:0c17:5c0e::2"; prefixLength = 64; }
        { address = "2a01:04f8:0c17:5c0e::4"; prefixLength = 64; }
        { address = "2a01:04f8:0c17:5c0e::8"; prefixLength = 64; }
        { address = "2a01:04f8:0c17:5c0e::16"; prefixLength = 64; }
      ];
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

  # Create webspaces and users
  system.activationScripts.create-varwww = "mkdir -p -m 0755 /var/www";
  users.mutableUsers = false;
  users.extraUsers = lib.genAttrs [
    "aquaregia"
    "aww"
    "brennblatt"
    "davidak"
    "default"
    "gnaclan"
    "kf"
    "meinsack"
    "personen"
    "piwik"
    "satzgenerator"
  ] (user:  {
    isNormalUser = true;
    home = "/var/www/${user}";
    openssh.authorizedKeys.keys = [ pubkey.davidak ];
  });
  system.activationScripts.webspace = "for dir in /var/www/*/; do chmod 0755 \${dir}; mkdir -p -m 0755 \${dir}/{web,log}; chown \$(stat -c \"%U:%G\" \${dir}) \${dir}/web; chown caddy:users \${dir}/log; done";
  system.activationScripts.default-site = "touch /var/www/default/web/index.html";

  # PHP-FPM
  services.phpfpm = {
    #phpPackage = pkgs.php56;
    phpOptions = ''
      date.timezone = "Europe/Berlin"
      ;memory_limit = 256M
      ;max_execution_time = 60

      # Problems with Caddy https://github.com/mholt/caddy/issues/1204
      #zend_extension = ${pkgs.php56}/lib/php/extensions/opcache.so
      #opcache.enable = 0
      #opcache.memory_consumption = 64
      #opcache.interned_strings_buffer = 16
      #opcache.max_accelerated_files = 10000
      #opcache.max_wasted_percentage = 5
      #opcache.use_cwd = 1
      #opcache.validate_timestamps = 1
      #opcache.revalidate_freq = 2
      #opcache.fast_shutdown = 1
    '';
    pools = {
      piwik = {
        extraConfig = ''
          user = piwik
          group = users
          listen.owner = caddy
          listen.group = caddy
          listen.mode = 0660

          pm = dynamic
          pm.max_children = 20
          pm.start_servers = 2
          pm.min_spare_servers = 1
          pm.max_spare_servers = 3
          pm.max_requests = 500
          chdir = /

          php_admin_value[always_populate_raw_post_data] = -1
        '';
        listen = "/run/phpfpm/piwik.sock";
      };
    gnaclan = {
      extraConfig = ''
        user = gnaclan
        group = users
        listen.owner = caddy
        listen.group = caddy
        listen.mode = 0660

        pm = dynamic
        pm.max_children = 10
        pm.start_servers = 2
        pm.min_spare_servers = 1
        pm.max_spare_servers = 3
        pm.max_requests = 500
        chdir = /
      '';
      listen = "/run/phpfpm/gnaclan.sock";
    };
    };
  };

  # test if issue is fixed in nixpkgs master
  # https://github.com/mholt/caddy/issues/1204
  # https://github.com/NixOS/nixpkgs/pull/22544
  nixpkgs.config.packageOverrides = super: let self = super.pkgs; in {
    caddy = (import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {}).caddy;
  };

  # Caddy Webserver
  services.caddy = {
    enable = true;
    email = "post@davidak.de";
    #ca = "https://acme-staging.api.letsencrypt.org/directory";
    agree = true;
    config = ''
    import /var/www/*/web/Caddyfile

    :80 {
      root /var/www/default/web
      header / X-Backend-Server {hostname}
    }
    '';
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";
}
