{ stdenv, fetchurl, python35Packages }:

python35Packages.buildPythonPackage rec {
  pname = "gvm-tools";
  version = "1.4.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/greenbone/${pname}/archive/v${version}.tar.gz";
    sha256 = "0vfwx93sm7r3s1svz3h22w9ns57v83yl57l8fpqj3nr83cv7kb4l";
  };

#  src = fetchPypi {
#    inherit pname version;
#    sha256 = "0pnq6j8f144virhri0drgf0058x6qcxfd5yrb0ynbwr8djh326yn";
#  };

  propagatedBuildInputs = with python35Packages; [ paramiko lxml defusedxml ];

  # module dialog missing in nixpkgs
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/greenbone/gvm-tools;
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
