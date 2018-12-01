{ config, pkgs, ... }:

{
  # install packages for software development
  environment.systemPackages = with pkgs; [
    # broken https://github.com/NixOS/nixpkgs/issues/48107
    #pipenv
    gitg
  ];
}
