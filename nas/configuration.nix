{ config, pkgs, ... }:

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

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };
    cleanTmpDir = true;
  };

  services.smartd = {
    enable = true;
    notifications = {
      mail.enable = true;
      wall.enable = false;
      #test = true;
    };
  };

  networking = rec {
    hostName = "nas";
    domain = "lan";

    # fix for missing hosts entry https://github.com/NixOS/nixpkgs/issues/1248
    extraHosts = ''
      127.0.0.1 localhost.localdomain localhost
      ${(builtins.head interfaces.enp6s0.ip4).address} ${hostName}.${domain} ${hostName}

      # The following lines are desirable for IPv6 capable hosts
      ::1     ip6-localhost ip6-loopback
      fe00::0 ip6-localnet
      ff00::0 ip6-mcastprefix
      ff02::1 ip6-allnodes
      ff02::2 ip6-allrouters
      ff02::3 ip6-allhosts
    '';

    interfaces = {
      enp6s0.ip4 = [ { address = "10.0.0.4"; prefixLength = 8; } ];
    };

    nameservers = [ "10.0.0.1" ];
    defaultGateway = "10.0.0.1";

    firewall = {
      enable = false;
      allowPing = true;
      allowedTCPPorts = [ 80 139 443 445 8384 31416 19999 ];
      allowedUDPPorts = [ 137 138 ];
    };

    useDHCP = false;
  };

  time.timeZone = "Europe/Berlin";
  i18n = {
    consoleKeyMap = "de";
    defaultLocale = "en_US.UTF-8";
  };

  # Monitoring
  services.netdata.enable = true;
  services.vnstat.enable = true;

  # SMB Shares
  services.samba = {
    enable = true;
    syncPasswordsByPam = true;
    shares = {
      Archiv = {
        path = "/data/archiv";
        public = false;
        writable = true;
      };
      Backup = {
        path = "/data/backup";
        public = false;
        writable = true;
      };
      Media = {
        path = "/data/media";
        public = false;
        writable = true;
      };
      Upload = {
        path = "/data/upload";
        public = true;
        writable = true;
      };
    };
    extraConfig = ''
      # login to guest if login fails
      map to guest = Bad User
      # fix error with no printers
      load printers = no
      printcap name = /dev/null
      printing = bsd
    '';
  };

  # fix error in service log
  security.pam.services.samba-smbd.limits = [
    { domain = "*"; type = "soft"; item = "nofile"; value = 16384; }
    { domain = "*"; type = "hard"; item = "nofile"; value = 32768; }
  ];

  users.extraUsers.davidak = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ pubkey.davidak ];
  };

  services.boinc = {
    enable = true;
    allowRemoteGuiRpc = true;
  };

  # Packages
  environment.systemPackages = with pkgs; [ btrfs-progs vnstat samba lm_sensors ];

  nix.useSandbox = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
}
