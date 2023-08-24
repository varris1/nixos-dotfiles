{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, gtk3
, gdk-pixbuf
, libdbusmenu-gtk3
, withWayland ? false
, gtk-layer-shell
, stdenv
, inputs
, makeRustPlatform
, system
}:

(makeRustPlatform {
  cargo = inputs.fenix.packages.${system}.minimal.toolchain;
  rustc = inputs.fenix.packages.${system}.minimal.toolchain;
}).buildRustPackage rec {
  pname = "eww";
  version = "unstable-2023-08-19";

  src = inputs.eww-git;
  cargoLock.lockFile = "${inputs.eww-git}/Cargo.lock";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 gdk-pixbuf libdbusmenu-gtk3 ] ++ lib.optional withWayland gtk-layer-shell;

  buildNoDefaultFeatures = true;
  buildFeatures = [
    (if withWayland then "wayland" else "x11")
  ];

  cargoBuildFlags = [ "--bin" "eww" ];

  cargoTestFlags = cargoBuildFlags;

  # requires unstable rust features
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "ElKowars wacky widgets";
    homepage = "https://github.com/elkowar/eww";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda lom ];
    mainProgram = "eww";
    broken = stdenv.isDarwin;
  };
}
