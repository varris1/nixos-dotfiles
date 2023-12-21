{
  stdenvNoCC,
  fetchFromGitHub,
  inputs,
  gtk3,
  fd,
  gnome-icon-theme,
  hicolor-icon-theme,
}:
stdenvNoCC.mkDerivation rec {
  pname = "gruvbox-plus-icon-pack";
  version = "9999";

  src = inputs.gruvbox-plus-icon-pack;

  nativeBuildInputs = [gtk3 fd];

  propagatedBuildInputs = [gnome-icon-theme hicolor-icon-theme];

  installPhase = ''
    cd Gruvbox-Plus-Dark
    fd " " -X rm
    mkdir -p $out/share/icons/Gruvbox-Plus-Dark
    cp -r * $out/share/icons/Gruvbox-Plus-Dark
  '';

  postFixup = ''
    for i in $out/share/icons/*; do
      gtk-update-icon-cache $i
    done
  '';

  dontDropIconThemeCache = true;
}
