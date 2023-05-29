{ stdenvNoCC, fetchFromGitHub, gtk3 }:

stdenvNoCC.mkDerivation rec {
  pname = "gruvbox-plus-icon-pack";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "SylEleuth";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HOgH7BPb3wsgrFEotz9+RNTZL7mYnI9Y58L5vxd/F2Y=";
  };

  nativeBuildInputs = [ gtk3 ];

  installPhase = ''
    mkdir -p $out/share/icons/GruvboxPlus
    cp -r * $out/share/icons/GruvboxPlus
    gtk-update-icon-cache $out/share/icons/GruvboxPlus
  '';

  dontDropIconThemeCache = true;
}
