{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.nix-ld = {
    enable = true;
    package = inputs.nix-ld-rs.packages.${pkgs.system}.nix-ld-rs;
    libraries = with pkgs; [
      stdenv.cc.cc
      fuse
      libpulseaudio
      vulkan-loader
      mesa
      libGL
      curl
      zlib
      libpulseaudio
    ];
  };
}
