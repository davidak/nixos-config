{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hardware.gpu.nvidia;
in
{
  options.hardware.gpu.nvidia = {
    enable = mkEnableOption "NVIDIA GPU";
  };

  config = mkIf cfg.enable {
    # use proprietary driver
    services.xserver.videoDrivers = [ "nvidia" ];
    nixpkgs.config.allowUnfree = true;

    # OpenCL support for BOINC
    services.boinc.extraEnvPackages = with pkgs; [ linuxPackages.nvidia_x11 ocl-icd ];

    meta = with lib; {
      maintainers = with maintainers; [ davidak ];
    };
  };
}
