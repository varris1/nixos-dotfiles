{
  stdenvNoCC,
  fetchFromGitHub,
  inputs,
  gtk3,
  gnome-icon-theme,
  hicolor-icon-theme,
}:
stdenvNoCC.mkDerivation rec {
  pname = "gruvbox-plus-icon-pack";
  version = "9999";

  src = inputs.gruvbox-plus-icon-pack;

  nativeBuildInputs = [gtk3];

  propagatedBuildInputs = [gnome-icon-theme hicolor-icon-theme];

  installPhase = ''
    cd Gruvbox-Plus-Dark
    mkdir -p $out/share/icons/Gruvbox-Plus-Dark
    cp -r * $out/share/icons/Gruvbox-Plus-Dark
  '';

  dontDropIconThemeCache = true;
}
