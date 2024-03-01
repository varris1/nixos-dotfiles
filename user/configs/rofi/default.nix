{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "kitty";
    extraConfig = {
      modi = "drun,run";
    };
    theme = ./theme.rasi;
  };
}
