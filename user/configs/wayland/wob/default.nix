{ lib, ... }:
{
  xdg.configFile."wob/wob.ini".text = lib.generators.toINIWithGlobalSection { } {
    globalSection = {
      height = "40";

      border_size = "2";
      border_color = "98971AFF";

      background_color = "282828FF";
      bar_color = "665C54FF";

    };
    sections = { };
  };
}

