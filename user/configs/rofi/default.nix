{ config, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "${pkgs.foot}/bin/foot";
    extraConfig = {
        modi = "drun,run,window";
    };
    theme = ./catppuccin-macchiato.rasi;
  };
}
