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

    themes = {
      custom-gruvbox = {
        inherits = "gruvbox";
        "ui.background" = {bg = "none";};
      };
    };

    settings = {
      theme = "custom-gruvbox";
      editor = {
        cursorline = true;
        line-number = "relative";
        color-modes = true;
        bufferline = "multiple";
        mouse = false;

        indent-guides.render = true;

        cursor-shape = {
          "insert" = "bar";
          "normal" = "block";
          "select" = "underline";
        };

        statusline = {
          separator = "|";

          left = ["mode" "separator" "spinner"];
          center = ["file-name"];
          right = ["selections" "file-type" "position"];

          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };

        lsp = {
          display-messages = true;
          display-inlay-hints = true;
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
          auto-format = true;
          formatter = ["alejandra"];
          language-servers = ["nixd"];
        }
      ];

      language-server.nixd = {
        command = "nixd";
      };

      formatter.alejandra = {
        command = "alejandra";
        args = ["-qq"];
      };
    };

    extraPackages = with pkgs; [
      alejandra
      nixd
      lua-language-server
      vscode-langservers-extracted
    ];
  };
}
