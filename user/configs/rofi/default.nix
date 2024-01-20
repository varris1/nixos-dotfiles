{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "wezterm";
    extraConfig = {
      modi = "drun,run";
    };
    theme = ./theme.rasi;
  };
}
