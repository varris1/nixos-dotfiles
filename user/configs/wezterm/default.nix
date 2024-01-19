{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.wezterm = {
    enable = true;
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

        config.color_scheme = 'Gruvbox Dark (Gogh)'

        return config
      '';
  };
}
