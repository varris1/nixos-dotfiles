{ config, lib, pkgs, inputs, ... }:
{
  home.packages = [
    pkgs.libsForQt5.qtstyleplugin-kvantum
  ];

  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "kvantum-dark";
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  xdg.configFile."Kvantum/kvantum.kvconfig".text = "theme=catppuccin";
  xdg.configFile."Kvantum/catppuccin/catppuccin.kvconfig".source = pkgs.catppuccin-kvantum-macchiato + "/share/Kvantum/Catppuccin-Macchiato-Blue/Catppuccin-Macchiato-Blue.kvconfig";
  xdg.configFile."Kvantum/catppuccin/catppuccin.svg".source = pkgs.catppuccin-kvantum-macchiato + "/share/Kvantum/Catppuccin-Macchiato-Blue/Catppuccin-Macchiato-Blue.svg";

}
