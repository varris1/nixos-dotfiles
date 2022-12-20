{ config, pkgs, ... }:
let
  colors = config.colorScheme.colors;
in
{
  programs.mako = {
    enable = true;
    anchor = "top-right";
    defaultTimeout = 5000;

    width = 320;
    height = 130;

    backgroundColor = "#${colors.base00}";
    borderColor = "#${colors.base01}";
    borderRadius = 10;
    borderSize = 2;

    font = "JetBrainsMono Nerd Font Regular 9";
  };
}

