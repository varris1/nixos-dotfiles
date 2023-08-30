{ pkgs, ... }:
{
  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ./config;
  };

  home.packages = [ pkgs.eww-hyprland-activewindow ];
}
