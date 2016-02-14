{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.0";
  name = "webseite-aquaregia-${version}";

  src = fetchFromGitHub {
    owner = "davidak";
    repo = "aquaregia.de";
    rev = "0d5988582ad1dc6e725dbff27232eb6d1527b59a";
    sha256 = "0qnmbr6w1yiarsx0bzixy706zz4p2ws24jrdngfybny7kzq2p5mp";
  };

  dontBuild = true;

  installPhase = ''
    cp -dr --no-preserve='ownership' . $out/
  '';

  meta = with stdenv.lib; {
    description = "Die Webseite der Band AquaRegia";
    homepage = "https://github.com/davidak/aquaregia.de";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ davidak ];
  };
}
