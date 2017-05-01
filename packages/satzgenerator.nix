{ stdenv, fetchFromGitHub, python35Packages }:

python35Packages.buildPythonPackage rec {
  name = "satzgenerator-${version}";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "davidak";
    repo = "satzgenerator.de";
    rev = "638f55daeb577a3b5190aba7e96dea725138c988";
    sha256 = "1qky2psv9cah4wjdilkr4sy5kfrgcakh8i55wcv5c373ifbjdd8w";
  };

  # no tests available
  doCheck = false;

  buildInputs = with python35Packages; [ bottle gunicorn sqlalchemy pymysql pyzufall ];

  meta = with stdenv.lib; {
    description = "satzgenerator.de";
    homepage = "https://satzgenerator.de/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ davidak ];
  };
}
