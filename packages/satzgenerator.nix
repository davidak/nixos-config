{ lib, fetchFromGitHub, python35Packages }:

python35Packages.buildPythonPackage rec {
  name = "satzgenerator-${version}";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "davidak";
    repo = "satzgenerator.de";
    rev = "b6b45cb8bbafd0aa98c9096e3ba6e91665ecbf5a";
    sha256 = "078fvh2hw7nj138ryyywjk6xvcw8lfnjzhxkca9cnfkcpf9i0zkl";
  };

  # no tests available
  doCheck = false;

  propagatedBuildInputs = with python35Packages; [ bottle gunicorn sqlalchemy pymysql pyzufall ];

  meta = with lib; {
    description = "satzgenerator.de";
    homepage = "https://satzgenerator.de/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ davidak ];
  };
}
