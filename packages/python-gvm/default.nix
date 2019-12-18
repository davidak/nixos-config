{ stdenv, lib, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "python-gvm";
  version = "1.1.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "338095add45b499fb5758e8bf7c87b809c09581244578c338b2f521e60453d63";
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
