{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "python-gvm";
  version = "unstable-2019-10-25";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "3079bddf3d27fd901ca7de85573aa75656c793d5";
    sha256 = "1hgkri6bwbzw62axwh2b0hh8a5sq3fzf2flwdhdcfkxv4ikhnfxk";
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
