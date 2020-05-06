{ config, ... }:

{
  services.boinc = {
    enable = true;
    allowRemoteGuiRpc = true;
  };
}
