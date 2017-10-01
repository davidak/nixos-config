{ config, pkgs, lib, ... }:

let
  pubkey = import ../service/pubkey.nix;
in
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../service/ssh.nix
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
    hostName = "carbon";
    domain = "lan";
    search = [ "${domain}" ];

    # fix for missing hosts entry https://github.com/NixOS/nixpkgs/issues/1248
    extraHosts = ''
    127.0.0.1 localhost.localdomain localhost
    10.0.0.23 ${hostName}.${domain} ${hostName}

    # The following lines are desirable for IPv6 capable hosts
    ::1     ip6-localhost ip6-loopback
    fe00::0 ip6-localnet
    ff00::0 ip6-mcastprefix
    ff02::1 ip6-allnodes
    ff02::2 ip6-allrouters
    ff02::3 ip6-allhosts
    '';

    interfaces = {
      enp0s3.ip4 = [ { address = "10.0.0.7"; prefixLength = 8; } ];
    };

    nameservers = [ "10.0.0.1" "8.8.8.8" ];
    defaultGateway = "10.0.0.1";

    firewall = {
      enable = false;
      allowPing = true;
      allowedTCPPorts = [ 80 443 8384 3306 8081 ];
      allowedUDPPorts = [];
    };

    useDHCP = false;
    enableIPv6 = false;
  };

  time.timeZone = "Europe/Berlin";
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "de";
    defaultLocale = "en_US.UTF-8";
  };

  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "de";
  services.xserver.xkbOptions = "eurosign:e";

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.mate.enable = true;

  # System Packages
  environment.systemPackages = with pkgs; [
    htop
    wget
    rsync
    mailutils
    tree
  ];

  users.extraUsers.davidak = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    uid = 1000;
    openssh.authorizedKeys.keys = [ pubkey.davidak ];
  };

  services.syncthing = {
    enable = true;
    user = "davidak";
  };

  nix.useSandbox = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.09";
}
