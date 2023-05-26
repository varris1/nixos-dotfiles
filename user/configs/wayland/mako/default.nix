{ config, pkgs, ... }:
{
  services.mako = {
    enable = true;
    anchor = "top-right";
    defaultTimeout = 5000;

    width = 440;
    height = 320;

    backgroundColor = "#282828B3";
    borderColor = "#98971aff";
    textColor = "#ebdbb2";
    progressColor = "over #665c54";
    borderRadius = 10;
    borderSize = 2;

    font = "JetBrainsMono Nerd Font Regular 10";
  };
}

