{ pkgs, config, lib, ... }:
{
  home.packages = [ pkgs.cava ];

  xdg.configFile."cava/config".text = lib.generators.toINI { } {
    general = {
      bar_width = "2";
    };
  };
}

