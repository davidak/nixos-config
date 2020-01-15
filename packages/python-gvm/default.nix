{ stdenv, lib, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "python-gvm";
  version = "1.2.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "cc15a4fb41fd53b286cb27205e9c7df1dcfd0cfc0d0579032ff8905a78f09659";
  };

  propagatedBuildInputs = with python3Packages; [ paramiko lxml defusedxml ];

  # no tests included on pypi
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/greenbone/python-gvm";
    description = "Greenbone Vulnerability Management Python Library";
    license = licenses.gpl3Plus;
    longDescription = ''
      The Greenbone Vulnerability Management Python API library (python-gvm)
      is a collection of APIs that help with remote controlling a Greenbone
      Security Manager (GSM) appliance and its underlying Greenbone
      Vulnerability Manager (GVM). The library essentially abstracts accessing
      the communication protocols Greenbone Management Protocol (GMP)
      and Open Scanner Protocol (OSP).
    '';
    maintainers = with maintainers; [ davidak ];
  };
}
