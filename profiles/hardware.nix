{ config, pkgs, ... }:

{
  # for hardware / bare metal systems

  # check S.M.A.R.T status of all disks and notify in case of errors
  services.smartd = {
    enable = true;
    notifications = {
      mail.enable = if config.services.postfix.enable then true else false;
      x11.enable = if config.services.xserver.enable then true else false;
      wall.enable = false;
      #test = true;
    };
  };

  # install packages
  environment.systemPackages = with pkgs; [
    lshw
    usbutils
    pciutils
    dmidecode
    lm_sensors
    smartmontools
  ];
}
