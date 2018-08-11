{ config, pkgs, ... }:

let
  pubkey = import ../../services/pubkey.nix;
in
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../profiles/hardware.nix
      ../../profiles/server.nix
      ../../services/avahi-server.nix
    ];

  boot.loader.grub.device = "/dev/sda";

  services.smartd = {
    enable = true;
    notifications = {
      mail.enable = true;
      wall.enable = false;
      #test = true;
    };
  };

  networking = {
    hostName = "nas";
    domain = "lan";

    bonds.bond0 = {
      interfaces = [ "enp6s0" "enp7s0" ];
      driverOptions = {
        mode = "balance-rr";
        miimon = "100";
      };
    };

    interfaces.bond0.ipv4.addresses = [ { address = "10.0.0.4"; prefixLength = 8; } ];

    nameservers = [ "10.0.0.1" ];
    defaultGateway = "10.0.0.1";

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ 80 139 443 445 5000 5001 8080 8384 9000 31416 19999 22000 ];
      allowedTCPPortRanges = [ { from = 4000; to = 4007; } ];
      allowedUDPPorts = [ 137 138 ];
    };

    useDHCP = false;
  };

  # Monitoring
  services.netdata = {
    enable = true;
    configText = ''
      [global]
      default port = 19999
      bind to = *
      # 7 days
      history = 604800
      error log = syslog
      debug log = syslog
    '';
  };
  services.vnstat.enable = true;

  systemd.extraConfig = ''
    DefaultCPUAccounting=yes
    DefaultIOAccounting=yes
    DefaultBlockIOAccounting=yes
    DefaultMemoryAccounting=yes
    DefaultTasksAccounting=yes
  '';

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

  # S3 compatible Object Storage
  services.minio = {
    enable = true;
    dataDir = "/data/minio";
    region = "eu-central-1";
  };

  users.extraUsers.davidak = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ pubkey.davidak ];
  };

  virtualisation.docker.enable = true;

  services.syncthing = {
    enable = true;
    user = "syncthing";
  };

  services.ipfs = {
    enable = true;
    swarmAddress = [ "/ip4/0.0.0.0/tcp/5000" "/ip6/::/tcp/5000" ];
    gatewayAddress = "/ip4/0.0.0.0/tcp/8080";
    autoMount = true;
    enableGC = true;
  };

  services.boinc = {
    enable = true;
    allowRemoteGuiRpc = true;
  };

  # Packages
  environment.systemPackages = with pkgs; [ btrfs-progs xfsprogs vnstat samba lm_sensors python3Packages.youtube-dl ];

  nix.useSandbox = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";
}
