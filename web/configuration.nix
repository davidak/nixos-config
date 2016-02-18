{ config, pkgs, lib, ... }:

let
  pubkey = import ../service/pubkey.nix;
in
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../service/fail2ban.nix
      ../service/postfix.nix
      ../service/ssh.nix
      ../service/ntp.nix
      ../service/vim.nix
    ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/vda";
  };

  networking = {
    hostName = "web";
    domain = "lan";

    interfaces = { 
      eth0.ip4 = [ { address = "10.0.0.17"; prefixLength = 8; } ]; 
    };

    nameservers = [ "10.0.0.1" ];
    defaultGateway = "10.0.0.1";

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ 80 ];
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
    tree
    mailutils
    git
  ];

  # Create all web users
  users.mutableUsers = false;
  users.extraUsers = lib.genAttrs [
    "wiki"
    "test"
  ] (user:  {
    isNormalUser = true;
    home = "/var/www/${user}";
    openssh.authorizedKeys.keys = [ pubkey.davidak ];
  });
  system.activationScripts.chmod-www = "chmod 0755 /var/www";
  system.activationScripts.webspaces = "for dir in /var/www/*/; do chmod 0755 \${dir}; mkdir -p -m 0755 \${dir}/{web,log}; chown \$(stat -c \"%U:%G\" \${dir}) \${dir}/web; done";

  services.phpfpm.poolConfigs = {
    wiki =
    ''
    listen = /run/phpfpm/wiki.sock
    listen.owner = wiki
    listen.group = nginx
    listen.mode = 0660

    user = wiki
    group = users

    pm = dynamic
    pm.max_children = 20
    pm.start_servers = 2
    pm.min_spare_servers = 1
    pm.max_spare_servers = 4
    pm.max_requests = 500

    chdir = /

    # php.ini settings
    php_admin_value[date.timezone] = "Europe/Berlin"
    php_admin_value[memory_limit] = 256M
    php_admin_value[max_execution_time] = 60
    '';
  };

  services.nginx = {
    enable = true;
    config = ''
      worker_processes  2;

      events {
        worker_connections  1024;
      }
    '';
    httpConfig = ''
      default_type  application/octet-stream;

      sendfile        on;
      keepalive_timeout  65;

      gzip              on;
      gzip_disable "MSIE [1-6]\.(?!.*SV1)";
      gzip_buffers      16 8k;
      gzip_comp_level   4;
      gzip_http_version 1.0;
      gzip_min_length   1000;
      gzip_types        text/plain text/css application/json application/javascript application/x-javascript text/xml application/xml application/xml+rss text/javascript image/x-icon image/bmp;
      gzip_vary         on;

      server {
        listen  80;
        server_name _;

        location / {
          root ${pkgs.nginx}/html;
          index index.html;
        }

        error_page  500 502 503 504 /50x.html;
        location = /50x.html {
          root   ${pkgs.nginx}/html;
        }

      }

      # Wiki
      server {
        listen 80;
        server_name wiki.lan;

        access_log /var/www/wiki/log/access.log;
        error_log /var/www/wiki/log/error.log;

        root /var/www/wiki/web;
        index index.php;
      
        location ~ \.php$ {
            include ${pkgs.nginx}/conf/fastcgi_params;
            try_files $uri =404;
            fastcgi_pass unix:/run/phpfpm/wiki.sock;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $document_root/$fastcgi_script_name;
        }
      }

      include /etc/nginx/conf.d/*;
    '';
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";
}
