{ stdenv, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "python-gvm";
  version = "1.0.0";
  name = "${pname}-${version}";

#  src = fetchurl {
#    url = "https://github.com/greenbone/${pname}/archive/v${version}.tar.gz";
#    sha256 = "0vfwx93sm7r3s1svz3h22w9ns57v83yl57l8fpqj3nr83cv7kb4l";
#  };

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "c8062e78b91bf71ff57ee91e35ae033eb2b9bc32c29ea67453c67351926ffb89";
  };

  propagatedBuildInputs = with python3Packages; [ paramiko lxml defusedxml ];

  # no tests included on pypi
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/greenbone/python-gvm;
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
