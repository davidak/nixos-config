{ config, pkgs, lib, ... }:

let
  email = "david.kleuker@greenbone.net";
in
{
  imports =
    [
      <home-manager/nixos>
    ];

  home-manager.users.davidak = { pkgs, ... }: {
    #home.packages = with pkgs; [ fortune ];

    programs.git = {
      enable = true;
      userName  = "David Kleuker";
      userEmail = email;
      #signing.key = "8CF1774E62AA8FFF3A61C57DB6839887B60197B0";
      extraConfig = { push = { default = "current"; }; };
    };
  };
}
