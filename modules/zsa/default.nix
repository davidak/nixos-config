{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.keyboard.zsa;

in

{
  options.hardware.keyboard.zsa = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enables udev rules for keyboards from ZSA like the ErgoDox EZ and Planck EZ.
        You need it when you want to flash a new configuration on the keyboard
        or use their live training in the browser.
        Access to the keyboard is granted to users in the "plugdev" group.
        You may want to install the wally-cli package.
      '';
    };

  };

  config = mkIf cfg.enable {
    #services.udev.packages = [ pkgs.libbladeRF ];
    services.udev.extraRules = ''
      # Rule for the Ergodox EZ Original / Shine / Glow
      SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
      # Rule for the Planck EZ Standard / Glow
      SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"

      # Teensy rules for the Ergodox EZ Original / Shine / Glow
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
      KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

      # STM32 rules for the Planck EZ Standard / Glow
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", \
          MODE:="0666", \
          SYMLINK+="stm32_dfu"
    '';
    users.groups.plugdev = {};
  };
}
