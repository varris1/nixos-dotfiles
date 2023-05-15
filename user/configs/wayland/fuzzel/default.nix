{ config, pkgs, lib, ... }:
let
  colors = config.colorScheme.colors;
in
{
  xdg.configFile."fuzzel/fuzzel.ini".text = lib.generators.toINIWithGlobalSection { } {
    globalSection = {
      font = "JetBrainsMono Nerd Font:size=8";
      layer = "overlay";
      terminal = "${pkgs.foot}/bin/foot -e";
      image-size-ratio = "0";

      width = "80";
      horizontal-pad = "20";
      line-height = "12";
    };
    sections = {
      border = {
        width = 2;
        radius = 0;
      };

      colors = {
        background = "${colors.base00}F2";
        text = "${colors.base06}FF";
        selection-text = "${colors.base06}FF";
        selection = "${colors.base01}FF";
        border = "${colors.base0F}FF";
        match = "${colors.base0F}FF";
        selection-match = "${colors.base0F}FF";
      };
    };
  };
}

