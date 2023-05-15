{ config, pkgs, lib, ... }:
let
  colors = config.colorScheme.colors;
in
{
  xdg.configFile."wob/wob.ini".text = lib.generators.toINIWithGlobalSection { } {
    globalSection = {
      height = "40";

      border_size = "2";
      border_color = "${colors.base0F}FF";

      background_color = "${colors.base00}FF";
      bar_color = "${colors.base0F}FF";

    };
    sections = { };
  };
}

