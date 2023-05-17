{ config, pkgs, lib, ... }:
{
  xdg.configFile."wob/wob.ini".text = lib.generators.toINIWithGlobalSection { } {
    globalSection = {
      height = "40";

      border_size = "2";
      border_color = "5A5F78FF";

      background_color = "24273AFF";
      bar_color = "8AADF4FF";

    };
    sections = { };
  };
}

