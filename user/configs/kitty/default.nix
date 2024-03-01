{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 10;
    };

    shellIntegration.enableFishIntegration = true;
    theme = "Gruvbox Dark";

    settings = {
      background_opacity = "0.9";
      modify_font = "cell_height 2px";
      shell_integration = "no-cursor";
      tab_bar_style = "powerline";
      window_padding_width = "14";
    };
  };
}
