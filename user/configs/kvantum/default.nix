{
  pkgs,
  inputs,
  ...
}: {
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

  xdg.configFile."Kvantum/kvantum.kvconfig".text = "theme=gruvbox-kvantum";
  xdg.configFile."Kvantum/gruvbox-kvantum/gruvbox-kvantum.kvconfig".source = inputs.gruvbox-kvantum + "/gruvbox-kvantum/gruvbox-kvantum.kvconfig";
  xdg.configFile."Kvantum/gruvbox-kvantum/gruvbox-kvantum.svg".source = inputs.gruvbox-kvantum + "/gruvbox-kvantum/gruvbox-kvantum.svg";
}
