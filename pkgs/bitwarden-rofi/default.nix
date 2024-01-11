# Shamelessly stolen from https://raw.githubusercontent.com/nix-community/nur-combined/master/repos/reedrw/pkgs/bitwarden-rofi/default.nix

{ stdenv
, lib
, fetchFromGitHub
, makeWrapper
, unixtools
, wl-clipboard
, ydotool
, bitwarden-cli
, rofi
, jq
, keyutils
, libnotify
}:
let
  bins = [
    bitwarden-cli
    jq
    keyutils
    libnotify
    rofi
    unixtools.getopt
    wl-clipboard
    ydotool
  ];
in
stdenv.mkDerivation rec {
  pname = "bitwarden-rofi";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "mattydebie";
    repo = "bitwarden-rofi";
    rev = "${version}";
    sha256 = "sha256-jXPwbvUTlMdwd/SYesfMuu7sQgR2WMiKOK88tGcQrcA="; 
  };

  buildInputs = [
    makeWrapper
  ];

  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "bwmenu" "$out/bin/bwmenu"
    install -Dm755 "lib-bwmenu" "$out/bin/lib-bwmenu" # TODO don't put this in bin

    install -Dm755 -d "$out/usr/share/doc/bitwarden-rofi"
    install -Dm755 -d "$out/usr/share/doc/bitwarden-rofi/img"

    install -Dm644 "README.md" "$out/usr/share/doc/bitwarden-rofi/README.md"
    install -Dm644 img/* "$out/usr/share/doc/bitwarden-rofi/img/"

    wrapProgram "$out/bin/bwmenu" --prefix PATH : ${lib.makeBinPath bins}
  '';

  meta = with lib; {
    description = "Wrapper for Bitwarden and Rofi";
    homepage = "https://github.com/mattydebie/bitwarden-rofi";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };

}

