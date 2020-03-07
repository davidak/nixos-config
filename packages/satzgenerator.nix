{ lib, fetchFromGitHub, python36Packages }:

python36Packages.buildPythonPackage rec {
  name = "satzgenerator-${version}";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "davidak";
    repo = "satzgenerator.de";
    rev = "1edd9c6cbfca02ed46f2d538d5cf0fb29857cdfb";
    sha256 = "0by0k36shl2gn7wlljs86vd3dg1dg2r10sq406r1b8pk8f9vmk0v";
  };

  # no tests available
  doCheck = false;

  propagatedBuildInputs = with python36Packages; [ bottle gunicorn sqlalchemy pymysql pyzufall ];

  meta = with lib; {
    description = "satzgenerator.de";
    homepage = "https://satzgenerator.de/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ davidak ];
  };
}
