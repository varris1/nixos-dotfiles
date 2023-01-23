{ config, pkgs, lib, ... }:
let
  wobsock = "/tmp/wob-volume.fifo";
in
stdenvNoCC.mkDerivation rec {
  pname = "custom-wlscripts";
  version = "1";

  phases = [ "installPhase" ];


  installPhase = ''
}

