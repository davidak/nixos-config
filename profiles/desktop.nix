{ config, pkgs, lib, ... }:

let
  unstable = import <nixos-unstable> {};
  inherit (lib) optionals;
in
{
  imports =
    [
      ./common.nix
      ../modules/zsa
      # TODO: simplify
      #../services/avahi.nix
      ../services/avahi-server.nix
      ../services/avahi-client.nix
      ../users/davidak/base.nix
    ];

  # boot splash instead of log messages
  boot.plymouth.enable = true;

  # use elementarys pantheon desktop environment
  services.xserver.enable = true;
  services.xserver.useGlamor = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.pantheon.enable = true;

  # disable xterm session
  services.xserver.desktopManager.xterm.enable = false;

  # enable flatpak support
  #services.flatpak.enable = true;
  #xdg.portal.enable = true;

  # enable fwupd, a DBus service that allows applications to update firmware
  #services.fwupd.enable = true;

  hardware.keyboard.zsa.enable = true;

  programs.ssh.startAgent = true;

  programs.chromium = {
    enable = true;
    extensions = [
      "cbnipbdpgcncaghphljjicfgmkonflee" # Axel Springer Blocker
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "hjdoplcnndgiblooccencgcggcoihigg" # Terms of Service; Didn’t Read
      "gcbommkclmclpchllfjekcdonpmejbdp" # HTTPS Everywhere
      "klbibkeccnjlkjkiokjodocebajanakg" # The Great Suspender
      "fngmhnnpilhplaeedifhccceomclgfbg" # EditThisCookie
      "oboonakemofpalcgghocfoadofidjkkk" # KeePassXC-Browser
      "fploionmjgeclbkemipmkogoaohcdbig" # Page load time
      "feeoiklfggbaibpdhkkngbpkppdmcjal" # Tab Counter
      "kglhbbefdnlheedjiejgomgmfplipfeb" # Jitsi Meetings
    ];
    extraOpts = {
      "BrowserSignin" = 0;
      "SyncDisabled" = true;
      "PasswordManagerEnabled" = false;
      "AutofillAddressEnabled" = true;
      "AutofillCreditCardEnabled" = false;
      "BuiltInDnsClientEnabled" = false;
      "MetricsReportingEnabled" = true;
      "SearchSuggestEnabled" = false;
      "AlternateErrorPagesEnabled" = false;
      "UrlKeyedAnonymizedDataCollectionEnabled" = false;
      "SpellcheckEnabled" = true;
      "SpellcheckLanguage" = [
                               "de"
                               "en-US"
                             ];
      "CloudPrintSubmitEnabled" = false;
    };
  };

  # install packages
  environment.systemPackages = with pkgs; [
    atom
    meld
    restic
    chromium
    firefox
    keepassx-community
    #libreoffice
    pantheon.notes-up
    #gnome-mpv
    simplescreenrecorder
    gimp
    todo-txt-cli
    python3Packages.xkcdpass
    python3Packages.youtube-dl
    asciinema
    remmina
    gparted
    neofetch
    twemoji-color-font
    appimage-run
  ] ++ optionals config.services.boinc.enable [ boinc ];
}
