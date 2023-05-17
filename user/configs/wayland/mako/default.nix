{ config, pkgs, ... }:
{
  services.mako = {
    enable = true;
    anchor = "top-right";
    defaultTimeout = 5000;

    width = 440;
    height = 320;

    backgroundColor = "#24273aB3";
    borderColor = "#8aadf4";
    textColor = "#cad3f5";
    progressColor = "over #363a4f" ;
    borderRadius = 10;
    borderSize = 2;

    font = "JetBrainsMono Nerd Font Regular 10";
  };
}

