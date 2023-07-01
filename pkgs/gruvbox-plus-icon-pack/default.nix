{ stdenvNoCC, fetchFromGitHub, gtk3, gnome-icon-theme, hicolor-icon-theme }:

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

  propagatedBuildInputs = [ gnome-icon-theme hicolor-icon-theme ];

  installPhase = ''
    mkdir -p $out/share/icons/GruvboxPlus
    cp -r * $out/share/icons/GruvboxPlus

    gtk-update-icon-cache $out/share/icons/GruvboxPlus
  '';

  dontDropIconThemeCache = true;
}
