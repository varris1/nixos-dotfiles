{ config, pkgs, ... }:
{
    programs.neovim = {
        enable = true;

        plugins = with pkgs.vimPlugins; [
                nvim-web-devicons
                catppuccin-nvim
                lualine-nvim
                bufferline-nvim
                nvim-colorizer-lua
                nvim-autopairs
                comment-nvim
                neo-tree-nvim
                nvim-notify
                which-key-nvim
                nvim-surround
                luasnip
                dressing-nvim

                telescope-nvim
                telescope-fzf-native-nvim

                nvim-lspconfig
                nvim-treesitter.withAllGrammars
                trouble-nvim
                vim-fugitive

                nvim-cmp
                lspkind-nvim
                cmp-cmdline
                cmp-path
                cmp-buffer
                cmp-nvim-lsp
                cmp_luasnip
                friendly-snippets
        ];

        extraLuaConfig = builtins.readFile ./init.lua;

        extraPackages = with pkgs; [
          nil
          lua-language-server
          clang-tools
        ];
    };
}

