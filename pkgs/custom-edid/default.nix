{ stdenvNoCC, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "edid-main-monitor";
  version = "1";

  edid = ./edid.bin;

  dontFixup = true;

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/lib/firmware/edid
    cp ${edid} $out/lib/firmware/edid/edid-EX2780Q.bin
  '';
}

