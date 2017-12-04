{ config, pkgs, ... }:

let
  secrets = import /root/secrets.nix;
in
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../profiles/server.nix
    ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/vda";
  };

  networking = {
    hostName = "transmission";
    domain = "lan";

    interfaces = {
      enp0s18.ip4 = [ { address = "10.0.0.16"; prefixLength = 8; } ];
    };

    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    # route external traffic through vpn gateway
    defaultGateway = "10.0.0.5";

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

  services.xserver.enable = false;

  services.transmission = {
    enable = true;
    port = 80;
    settings = {
      rpc-bind-address = "10.0.0.16";
      rpc-whitelist-enabled = true;
      rpc-whitelist = "10.*";
      rpc-enabled = true;
      rpc-username = secrets.transmission-user;
      rpc-password = secrets.transmission-password;
      download-dir = "/var/lib/transmission/downloads/";
      incomplete-dir = "/var/lib/transmission/.incomplete/";
      incomplete-dir-enabled = true;
      ratio-limit-enabled = true;
      ratio-limit = 2;
      peer-limit-global = 512;
      peer-limit-per-torrent = 128;
      port-forwarding-enabled = false;
      blocklist-enabled = true;
      blocklist-url = "http://john.bitsurge.net/public/biglist.p2p.gz";
    };
  };
  systemd.services.transmission.serviceConfig.AmbientCapabilities = "cap_net_bind_service";

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";
}
