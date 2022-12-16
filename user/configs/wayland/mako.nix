{ config, pkgs, ... }:
{
  programs.mako = {
    enable = true;
    anchor = "top-right";
    defaultTimeout = 5000;

    width = 320;
    height = 130;

    backgroundColor = "#282828";
    borderColor = "#3C3836";
    borderRadius = 10;
    borderSize = 2;

    font = "JetBrainsMono Nerd Font Regular 9";
  };
}

