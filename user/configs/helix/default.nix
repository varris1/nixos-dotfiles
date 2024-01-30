{
  config,
  inputs,
  pkgs,
  flakeDir,
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
        "ui.statusline.normal" = {
          bg = "#AA9A85";
          fg = "#232323";
          modifiers = ["bold"];
        };
        "ui.statusline.insert" = {
          bg = "#84A799";
          fg = "#232323";
          modifiers = ["bold"];
        };
        "ui.statusline.select" = {
          bg = "#FE8112";
          fg = "#232323";
          modifiers = ["bold"];
        };
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

          left = ["mode" "file-name"];
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
        space."e" = ":open ${flakeDir}";
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
