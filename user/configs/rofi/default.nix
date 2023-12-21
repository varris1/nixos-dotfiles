{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = {
      modi = "drun,run";
    };
    theme = ./theme.rasi;
  };
}
