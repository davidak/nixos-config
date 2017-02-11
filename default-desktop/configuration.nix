{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking = {
    hostName = "default";
    domain = "lan";

    interfaces = {
      enp0s3.ip4 = [ { address = "10.0.0.252"; prefixLength = 8; } ];
    };

    nameservers = [ "10.0.0.1" "8.8.4.4" ];
    defaultGateway = "10.0.0.1";

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };

    useDHCP = false;
  };

  hardware.pulseaudio.enable = true;

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
    git
  ];

  services.postfix.enable = true;
  services.fail2ban.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "de";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  #services.xserver.displayManager.kdm.enable = true;
  #services.xserver.desktopManager.kde5.enable = true;

  # Enable Gnome 3 Desktop
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome3.enable = true;

  # Enable Xfce Desktop
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # other desktops
  #services.xserver.displayManager.slim.enable = true;
  #services.xserver.windowManager.openbox.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";
  users.extraUsers.root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0gSy7qdULWLSpGuGM6BAoFztX123g/cbW6x3TfzKo0s59y9OrzHrCSTYg3QN9BY1jLRp5DSMjHvsPS1Z/yp3EIJJS/dDso5/noDqOMBLOQgIdCLKipTudngpFDvnCAAg0IQl6iuVRznQvq9Xww65uYyR3OAv4DMvHFQn0qa5G3ZHCoj7I6FATTwGDKPeuqVF2MtdXC1XXx7v7zsar1sBhibUlbWSWhSvw+vhM+Qtj95wkHzI8O93Xy8Vqb5/OoXQDGyA0MnORCLeE8t7EvUi9ukXGz6QMwRX/T1RTLBP+pvrT5UyPtchzgZigbxvegnAy8HRA7I9TlUSFnTVvN6sg6z7n/F09HX1ETBv1qce/uuDc+npfM6Kdykz93ydro1ZfnPabD6rvie972EK5IVsO6n5066vVVhUt9QxDl2CDa0tLBxnGovvV1nmtcjq2AewOX2vj5qD0U256AiiS8tNA0i9GQLW90x6o1/Ih2xaPagfrRmpQjR1ecbEFYxT34Lp5ZuC9x5Nm67RGb4JvvbMrz3qjR5YARKOiryJ5owrN3TUJmYp75xT7QBGkXBwhQJZwwBFhg5rKC5BJIj5x4PGJXrwHHuk6gpbLRbgoT69NmJYIkKZaPSIt+oOzVmgKBM5LTtI4JI8kPs2CHo2FwuYAnP9XAfGoTuB/Ir9ECkFoEQ== davidak" ];

  users.extraUsers.davidak = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    uid = 1000;
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0gSy7qdULWLSpGuGM6BAoFztX123g/cbW6x3TfzKo0s59y9OrzHrCSTYg3QN9BY1jLRp5DSMjHvsPS1Z/yp3EIJJS/dDso5/noDqOMBLOQgIdCLKipTudngpFDvnCAAg0IQl6iuVRznQvq9Xww65uYyR3OAv4DMvHFQn0qa5G3ZHCoj7I6FATTwGDKPeuqVF2MtdXC1XXx7v7zsar1sBhibUlbWSWhSvw+vhM+Qtj95wkHzI8O93Xy8Vqb5/OoXQDGyA0MnORCLeE8t7EvUi9ukXGz6QMwRX/T1RTLBP+pvrT5UyPtchzgZigbxvegnAy8HRA7I9TlUSFnTVvN6sg6z7n/F09HX1ETBv1qce/uuDc+npfM6Kdykz93ydro1ZfnPabD6rvie972EK5IVsO6n5066vVVhUt9QxDl2CDa0tLBxnGovvV1nmtcjq2AewOX2vj5qD0U256AiiS8tNA0i9GQLW90x6o1/Ih2xaPagfrRmpQjR1ecbEFYxT34Lp5ZuC9x5Nm67RGb4JvvbMrz3qjR5YARKOiryJ5owrN3TUJmYp75xT7QBGkXBwhQJZwwBFhg5rKC5BJIj5x4PGJXrwHHuk6gpbLRbgoT69NmJYIkKZaPSIt+oOzVmgKBM5LTtI4JI8kPs2CHo2FwuYAnP9XAfGoTuB/Ir9ECkFoEQ== davidak" ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";
}
