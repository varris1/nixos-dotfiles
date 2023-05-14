{ config, pkgs, ... }:
let
  colors = config.colorScheme.colors;
in
{
  services.mako = {
    enable = true;
    anchor = "top-right";
    defaultTimeout = 5000;

    width = 440;
    height = 320;

    backgroundColor = "#${colors.base00}B3";
    borderColor = "#${colors.base01}";
    borderRadius = 10;
    borderSize = 2;

    font = "JetBrainsMono Nerd Font Regular 10";
  };
}

