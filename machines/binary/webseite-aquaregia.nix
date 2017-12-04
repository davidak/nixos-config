{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.0";
  name = "webseite-aquaregia-${version}";

  src = fetchFromGitHub {
    owner = "davidak";
    repo = "aquaregia.de";
    rev = "afd9f97f2014ae6a8cd96b917cf9af3ecea64446";
    sha256 = "1dfxkv8275lggdr3m8qx8hwjs4wiq1b1hlva0hj07xdl7q2b0sdn";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    cp -dr --no-preserve='ownership' . $out/
  '';

  meta = with stdenv.lib; {
    description = "Die Webseite der Band AquaRegia";
    homepage = "https://github.com/davidak/aquaregia.de";
    license = licenses.cc-by-sa-40;
    platforms = platforms.all;
    maintainers = with maintainers; [ davidak ];
  };
}
