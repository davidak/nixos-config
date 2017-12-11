{ config, ... }:

{
  # english locales, german keyboard layout
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "de";
    defaultLocale = "en_US.UTF-8";
  };

  services.xserver.layout = "de";
  services.xserver.xkbOptions = "eurosign:e";

  time.timeZone = "Europe/Berlin";
}
