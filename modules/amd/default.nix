{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hardware.gpu.amd;
in
{
  options.hardware.gpu.amd = {
    enable = mkEnableOption "AMD GPU";
  };

  config = mkIf cfg.enable {
    # use open source driver
    services.xserver.videoDrivers = [ "amdgpu" ];

    # OpenCL support for BOINC
    services.boinc.extraEnvPackages = with pkgs; [ ocl-icd ];

    # Fix OpenCL https://github.com/NixOS/nixpkgs/pull/82729
    hardware.opengl = let
        opencl_pr = import (builtins.fetchTarball {
            name = "opencl_pr";
            url = "https://github.com/athas/nixpkgs/archive/f92a2a9b69eba9909d25ffaab6ded4d6f0f4efad.tar.gz";
        }) { };
    in {
        enable = true;
        driSupport32Bit = true;
        package = opencl_pr.mesa.drivers;
        extraPackages = [ opencl_pr.mesa ];
    };

    meta = with lib; {
      maintainers = with maintainers; [ davidak ];
    };
  };
}
