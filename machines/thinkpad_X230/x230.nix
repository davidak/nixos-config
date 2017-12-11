{ config, pkgs, ... }:

{
  hardware.cpu.intel.updateMicrocode = true;
  services.xserver.videoDrivers = [ "intel" ];

  # TPM chip countains a RNG
  security.rngd.enable = true;

  # hard disk protection if the laptop falls
  services.hdapsd.enable = true;
}
