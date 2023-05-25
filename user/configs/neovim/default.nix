{ pkgs, ... }:
{
    programs.neovim = {
        enable = true;

        plugins = with pkgs.vimPlugins; [
                bufferline-nvim
                catppuccin-nvim
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

                vim-fugitive

                telescope-nvim
                telescope-fzf-native-nvim

                nvim-lspconfig
                nvim-treesitter.withAllGrammars
                trouble-nvim

                nvim-cmp
                cmp-buffer
                cmp-cmdline
                cmp-nvim-lsp
                cmp-path
                cmp_luasnip
                friendly-snippets
                lspkind-nvim
        ];

        extraLuaConfig = builtins.readFile ./init.lua;

        extraPackages = with pkgs; [
          clang-tools
          lua-language-server
          nil
          rust-analyzer
          nodePackages.vscode-css-languageserver-bin
        ];
    };
}

