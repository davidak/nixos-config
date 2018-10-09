{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../profiles/hardware.nix
      ../../profiles/notebook.nix
      ../../profiles/desktop.nix
      ../../profiles/work.nix
      ../../profiles/communication.nix
    ];

  # Use the systemd-boot EFI boot loader
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/b13d00fa-c3b1-4519-b483-f731028724d0";
      preLVM = true;
      allowDiscards = true;
    }
  ];

  # no access time and continuous TRIM for SSD
  fileSystems."/".options = [ "noatime" "discard" ];
  fileSystems."/boot".options = [ "noatime" "discard" ];

  networking = {
    hostName = "ethmoid";
    domain = "devel.greenbone.net";

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };

  nixpkgs.overlays = [
  (self: super:
  {
    gvm-tools = super.callPackage ../../packages/gvm-tools { };
  }
  )];

  # user for GSM scan test
  services.openssh.passwordAuthentication = true;
  users.extraUsers.scanuser = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDhvY8BPq1t9tHc874rdp6AyxxTFHajYGjl+Oh0HQ41sEMEGibDUHQRuOFPI6pO8XOEm+YvHWzWawzk7JBJXXPhHNdcEsjeHV4nVqmaCddGHRtTIgEjXBeZiaeiCo07SBYEZ3L6M/6CuL4AJZEc5EbGeTr4VRPpf/jO66MKjYtTCEYqOUSkjNbEZ1qYew8VX52qCoEnGx/ZK7qqnbopvPK1epQc2CQRed01FE24H2EiRbxMvk4v+P55zUK6aY0MSg21crawE5PQ/Fv0fYDQcyNjQGpVEtY9SeLxkLXlwZ8myHJJ9PQrlksYe+Wldu4g05vajqEff15POVs5s/IZdtL95eKs5zIocH+QmLBbMtuGN5+OgDrVPusDhJXIfg/NzuR2z4o8PIlY+AhXiozj4+Qg6vBAWabk5NKr5pY+ASa0pWTEjolKw3WIbpLJy40gMjnfj61h8LZHyVp+84LkVmXZh+4TYD/ix2QUxvbRsfvIJEPd+zQuC7xrt50h+W5/ye987sySux/xWIAClA33fBm0gyQ5/GvmkyTHPQDavF9ZnG0xQN3De2bMnFfYnFfIwF5k/JHfTB6/4GpJimdgSSrX5n2BeeejTUPxbfjN44EUTmQQosiU/X3Z6IjGUd9P2xmreJCU8VCurW95puEED314FcO+oWRN8jBP6X1ChJ8dlQ== GSM Test SSH-Key" ];
  };

  # Packages
  environment.systemPackages = with pkgs; [ gvm-tools ];

  # compatible NixOS release
  system.stateVersion = "18.03";
}
