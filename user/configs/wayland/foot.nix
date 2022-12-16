{ config, pkgs, inputs, ... }:
let
  colors = config.colorScheme.colors;
in
{

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:pixelsize=12";
        box-drawings-uses-font-glyphs = "yes";
        pad = "16x16 center";
      };

      colors = {
        alpha = "0.95";
        background = "${colors.base00}";
        foreground = "${colors.base06}";
        regular0 = "${colors.base01}";
        regular1 = "${colors.base08}";
        regular2 = "${colors.base0B}";
        regular3 = "${colors.base0A}";
        regular4 = "${colors.base0D}";
        regular5 = "${colors.base0E}";
        regular6 = "${colors.base0C}";
        regular7 = "${colors.base05}";
        bright0 = "${colors.base02}";
        bright1 = "${colors.base07}";
        bright2 = "${colors.base0B}";
        bright3 = "${colors.base0A}";
        bright4 = "${colors.base0C}";
        bright5 = "${colors.base0E}";
        bright6 = "${colors.base0F}";
        bright7 = "${colors.base06}";

        selection-foreground = "000000";
        selection-background = "FFFACD";
        urls = "0087BD";
      };
    };
  };
}

