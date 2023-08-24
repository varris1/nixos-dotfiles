{ pkgs, ... }:
let

  inherit (import ./config.nix { inherit pkgs; }) eww-config;
  inherit (import ./stylesheet.nix) eww-stylesheet;

in
{
  xdg.configFile."eww/eww.yuck".text = "${eww-config}";
  xdg.configFile."eww/eww.scss".text = "${eww-stylesheet}";

  home.packages = [ pkgs.eww-git ];
}
