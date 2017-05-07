{ stdenv, pkgs, fetchgit, pkgconfig, attr, libuuid, libsodium, keyutils, liburcu, zlib, libaio }:

let
  libscrypt = pkgs.callPackage ./libscrypt.nix { };
in
stdenv.mkDerivation rec {
  name = "bcachefs-tools-${version}";
  version = "git";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs-tools.git";
    rev = "f9395eeca59290b210bc2b79f7bf2e9cb779cf3f";
    sha256 = "1jgz96pa217cjclxfxlcmbkxsw1kcn7zswwyhfbfkmrjbr1wdw93";
  };

  buildInputs = [ pkgconfig attr libuuid libscrypt libsodium keyutils liburcu zlib libaio ];

  preConfigure = ''
    substituteInPlace cmd_migrate.c --replace /usr/include/dirent.h ${stdenv.glibc.dev}/include/dirent.h
  '';

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "tool for managing bcachefs filesystems";
    longDescription = ''
    The bcachefs tool, which has a number of subcommands for formatting
    and managing bcachefs filesystems.
    '';
    homepage = "http://bcachefs.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak ];
    platforms = platforms.linux;
  };
}
