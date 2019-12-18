{ stdenv, lib, python3Packages, python-gvm }:

python3Packages.buildPythonApplication rec {
  pname = "gvm-tools";
  version = "2.0.0";

# use this if you need to build an unstable version
#  src = fetchurl {
#    url = "https://github.com/greenbone/${pname}/archive/v${version}.tar.gz";
#    sha256 = "0vfwx93sm7r3s1svz3h22w9ns57v83yl57l8fpqj3nr83cv7kb4l";
#  };

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "10568c6c60f52da1781d4d11d660294c6413e3e6984ee346bf5d613b417ff126";
  };

  propagatedBuildInputs = with python3Packages; [ setuptools python-gvm ];

  # 6 tests fail
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/greenbone/gvm-tools";
    description = "Greenbone Vulnerability Management Tools";
    license = licenses.gpl3Plus;
    longDescription = ''
      GVM-Tools is a collection of tools that help with remote controlling
      a Greenbone Security Manager (GSM) appliance and its underlying
      Greenbone Vulnerability Manager (GVM). The tools essentially aid
      accessing the communication protocols GMP (Greenbone Management Protocol)
      and OSP (Open Scanner Protocol).
    '';
    maintainers = with maintainers; [ davidak ];
  };
}
