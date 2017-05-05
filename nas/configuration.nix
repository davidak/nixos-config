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

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking = rec {
    hostName = "NAS";
    domain = "lan";

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

#    interfaces = {
#      enp0s18.ip4 = [ { address = "10.0.0.252"; prefixLength = 8; } ];
#    };

#    nameservers = [ "10.0.0.1" "8.8.8.8" ];
#    defaultGateway = "10.0.0.1";

    firewall = {
      enable = false;
      allowPing = true;
      allowedTCPPorts = [ 80 443 8384 19999 ];
      allowedUDPPorts = [];
    };

#    useDHCP = false;
    useDHCP = true;
  };

  time.timeZone = "Europe/Berlin";
  i18n = {
    consoleKeyMap = "de";
    defaultLocale = "de_DE.UTF-8";
  };

  # Monitoring
  services.netdata.enable = true;
  services.vnstat.enable = true;

  # SMB Shares
  services.samba = {
    enable = true;
    syncPasswordsByPam = true;
    extraConfig = ''
      [backup]
      path = /data/backup
      read only = no
      guest ok = no

      [bilder]
      path = /data/bilder
      read only = no
      guest ok = yes

      [musik]
      path = /data/musik
      read only = no
      guest ok = yes

      [videos]
      path = /data/videos
      read only = no
      guest ok = yes
    '';
  };

  users.extraUsers.davidak = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ pubkey.davidak ];
  };

  # Packages
  environment.systemPackages = with pkgs; [ vnstat samba ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
}
