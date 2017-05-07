{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "libscrypt-${version}";
  version = "1.21";

  src = fetchFromGitHub {
    owner = "technion";
    repo = "libscrypt";
    rev = "v${version}";
    sha256 = "1d76ys6cp7fi4ng1w3mz2l0p9dbr7ljbk33dcywyimzjz8bahdng";
  };

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "shared library that implements scrypt() functionality - a replacement for bcrypt()";
    longDescription = ''
    '';
    homepage = "https://lolware.net/2014/04/29/libscrypt.html";
    license = licenses.bsd2;
    maintainers = with maintainers; [ davidak ];
    platforms = platforms.unix;
  };
}
