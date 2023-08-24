{ stdenvNoCC, fetchFromGitHub, gtk3, gnome-icon-theme, hicolor-icon-theme }:

stdenvNoCC.mkDerivation rec {
  pname = "gruvbox-plus-icon-pack";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "SylEleuth";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KefCHHFtuh2wAGBq6hZr9DpuJ0W99ueh8i1K3tohgG8=";
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
