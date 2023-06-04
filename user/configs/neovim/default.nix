{ pkgs, ... }:
{
    programs.neovim = {
        enable = true;

        plugins = with pkgs.vimPlugins; [
                bufferline-nvim
                gruvbox-nvim
                comment-nvim
                dressing-nvim
                lualine-nvim
                luasnip
                neo-tree-nvim
                nvim-autopairs
                nvim-colorizer-lua
                nvim-notify
                nvim-surround
                nvim-web-devicons
                which-key-nvim
                smart-splits-nvim
                legendary-nvim
                vim-easy-align

                vim-fugitive

                telescope-nvim
                telescope-fzf-native-nvim
                telescope-ui-select-nvim
                telescope-undo-nvim

                nvim-lspconfig
                nvim-treesitter.withAllGrammars
                trouble-nvim

                nvim-cmp
                cmp-buffer
                cmp-cmdline
                cmp-nvim-lsp
                cmp-path
                cmp_luasnip
                cmp-nvim-lsp-signature-help
                friendly-snippets
                lspkind-nvim
        ];

        extraPackages = with pkgs; [
          nodePackages.bash-language-server
          clang-tools
          lua-language-server
          python3Packages.jedi-language-server
          rnix-lsp
          rust-analyzer
          nodePackages.vscode-css-languageserver-bin
          zls
        ];
    };

    xdg.configFile.nvim = {
      source = ./config;
      recursive = true;
    };
}

