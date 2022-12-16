{ config, pkgs, lib, ... }:
{
  xdg.configFile."wob/wob.ini".text = lib.generators.toINIWithGlobalSection { } {
    globalSection = {
      height = "40";

      border_size = "2";
      border_color = "D65D0EFF";

      background_color = "282828FF";
      bar_color = "D65D0EFF";

    };
    sections = { };
  };
}

