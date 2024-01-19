{
  config,
  inputs,
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.helix;
    defaultEditor = true;

    settings = {
      theme = "gruvbox";

      editor = {
        line-number = "relative";
        color-modes = true;
        bufferline = "multiple";
        mouse = false;

        indent-guides.render = true;

        statusline = {
          left = ["mode" "spinner"];
          center = ["file-name"];
          right = [];

          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };

        lsp = {
          display-messages = true;
        };
      };

      keys.normal = {
        "esc" = ["collapse_selection" "keep_primary_selection"];
        space."e" = ":open ~/.dotfiles";
      };
    };

    languages = {
      language = [
        {
          name = "nix";
          language-servers = ["nixd"];
        }
      ];

      language-server.nixd = {
        command = "${pkgs.nixd}/bin/nixd";
      };
    };
  };
}
