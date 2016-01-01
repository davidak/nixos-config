{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/vda";
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  networking = {
    hostName = "cg-gw";
    domain = "lan";

    interfaces = {
      eth0.ip4 = [ { address = "10.0.0.13"; prefixLength = 8; } ];
      eth1.ip4 = [ { address = "10.0.0.5"; prefixLength = 8; } ];
    };

    nameservers = [ "10.0.0.1" ];
    defaultGateway = "10.0.0.1";

    firewall = {
      enable = false;
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
    unzip
    mailutils
  ];

  services.postfix.enable = true;
  services.fail2ban.enable = true;
  services.xserver.enable = false;

  services.openvpn = {
    enable = true;
    servers = {
      cyberghost = {
        config = ''
          client
          remote 8-ro.cg-dialup.net 443
          dev tun0
          proto tcp
          auth-user-pass /root/.vpn/user.txt

          resolv-retry infinite
          redirect-gateway def1
          persist-key
          persist-tun
          nobind
          cipher AES-256-CBC
          auth MD5
          ping 15
          ping-exit 90
          ping-timer-rem
          script-security 2
          remote-cert-tls server
          route-delay 5
          verb 4
          comp-lzo

          ca /root/.vpn/ca.crt
          cert /root/.vpn/client.crt
          key /root/.vpn/client.key
        '';
        up = ''
          iptables -A FORWARD -s 10.0.0.0/8 -i eth1 -o eth0 -m conntrack --ctstate NEW -j REJECT
          iptables -A FORWARD -s 10.0.0.0/8 -i eth1 -o tun0 -m conntrack --ctstate NEW -j ACCEPT
          iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
          echo nameserver $nameserver | ${pkgs.openresolv}/sbin/resolvconf -m 0 -a $dev
        '';
        down = "${pkgs.openresolv}/sbin/resolvconf -d $dev";
        autoStart = true;
      };
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";
  users.extraUsers.root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0gSy7qdULWLSpGuGM6BAoFztX123g/cbW6x3TfzKo0s59y9OrzHrCSTYg3QN9BY1jLRp5DSMjHvsPS1Z/yp3EIJJS/dDso5/noDqOMBLOQgIdCLKipTudngpFDvnCAAg0IQl6iuVRznQvq9Xww65uYyR3OAv4DMvHFQn0qa5G3ZHCoj7I6FATTwGDKPeuqVF2MtdXC1XXx7v7zsar1sBhibUlbWSWhSvw+vhM+Qtj95wkHzI8O93Xy8Vqb5/OoXQDGyA0MnORCLeE8t7EvUi9ukXGz6QMwRX/T1RTLBP+pvrT5UyPtchzgZigbxvegnAy8HRA7I9TlUSFnTVvN6sg6z7n/F09HX1ETBv1qce/uuDc+npfM6Kdykz93ydro1ZfnPabD6rvie972EK5IVsO6n5066vVVhUt9QxDl2CDa0tLBxnGovvV1nmtcjq2AewOX2vj5qD0U256AiiS8tNA0i9GQLW90x6o1/Ih2xaPagfrRmpQjR1ecbEFYxT34Lp5ZuC9x5Nm67RGb4JvvbMrz3qjR5YARKOiryJ5owrN3TUJmYp75xT7QBGkXBwhQJZwwBFhg5rKC5BJIj5x4PGJXrwHHuk6gpbLRbgoT69NmJYIkKZaPSIt+oOzVmgKBM5LTtI4JI8kPs2CHo2FwuYAnP9XAfGoTuB/Ir9ECkFoEQ== davidak" ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";
}
