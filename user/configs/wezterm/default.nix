{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.wezterm = {
    enable = true;
    package = inputs.wezterm.packages.${pkgs.system}.default;
    extraConfig =
      /*
      lua
      */
      ''
        local wezterm = require("wezterm")
        local config = {}

        if wezterm.config_builder then
          config = wezterm.config_builder()
        end

        config = {
          font = wezterm.font "JetBrainsMono Nerd Font",
          font_size = 10,

          color_scheme = "Gruvbox Dark (Gogh)",
          hide_tab_bar_if_only_one_tab = true,
          line_height = 1.1,
          window_background_opacity = 0.9,
          window_close_confirmation = "NeverPrompt",

          window_padding = {
            left = "20",
            right = "20",
            top = "20",
            bottom = "20",
          },
        }

        return config
      '';
  };
}
