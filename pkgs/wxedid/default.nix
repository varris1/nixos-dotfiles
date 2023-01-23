{ lib, stdenv, fetchurl, wxGTK32 }:

stdenv.mkDerivation rec {
  pname = "wxedid";
  version = "0.0.27";
  src = fetchurl {
    url = "https://downloads.sourceforge.net/${pname}/${pname}-${version}.tar.gz";
    sha256 = "KBIGrzsJ40TEsz+kJQZi9BPPFPITfVRrTlc1FYqdFfo=";
  };

  postPatch = ''
    patchShebangs --build src/rcode/rcd_autogen
  '';

  buildInputs = [ wxGTK32 ];
}
