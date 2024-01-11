{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "hyprland-workspaces";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "FieldofClay";
    repo = "hyprland-activewindow";
    rev = "v${version}";
    hash = "sha256-DaQrVXrmDr1v/nECTVMfTrIgFe7j1dNLLGCjYeBfRpU=";
  };

  cargoHash = "sha256-wktlWAJ+cJNv+2Lrv2dys5yA2BUaU3EnvVjgEUocvaI=";
}
