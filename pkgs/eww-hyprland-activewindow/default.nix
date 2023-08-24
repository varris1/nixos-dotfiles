{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, makeRustPlatform
, system
, inputs
}:

(makeRustPlatform {
  cargo = inputs.fenix.packages.${system}.default.toolchain;
  rustc = inputs.fenix.packages.${system}.default.toolchain;
}).buildRustPackage rec {
  pname = "hyprland-activewindow";
  version = "v0.4.1";

  src = fetchFromGitHub {
    owner = "FieldofClay";
    repo = "hyprland-activewindow";
    rev = "${version}";
    hash = "sha256-Y/idFeBY6u0kvLnS6w5Kd5tRRM5OAkI+210cx83T4ys=";
  };
  
  cargoHash = "sha256-3K7MmLobn+Cp8AbMCjloS4zqsL7LTyMUh62G2jyZCB0=";
  cargoPatches = [ ./bumpdeps.diff ];
}
