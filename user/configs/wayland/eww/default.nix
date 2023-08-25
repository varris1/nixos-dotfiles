{ pkgs, ... }:
let

  inherit (import ./panel/config.nix { inherit pkgs; }) panel-config;
  inherit (import ./panel/stylesheet.nix) panel-stylesheet;

in
{
  xdg.configFile."eww/eww.yuck".text = ''
    ${panel-config}
    '';
  xdg.configFile."eww/eww.scss".text = ''
    ${panel-stylesheet}
    '';

  home.packages = [ pkgs.eww-git ];
}
