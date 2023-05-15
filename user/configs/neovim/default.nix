{ config, pkgs, lib, inputs, ... }:
{
    programs.neovim = {
        enable = true;

        plugins = with pkgs.vimPlugins; [
            gruvbox-nvim
                nvim-web-devicons
                lualine-nvim
                bufferline-nvim
                nvim-colorizer-lua
                nvim-autopairs
                comment-nvim
                neo-tree-nvim
                nvim-notify
                nvim-treesitter.withAllGrammars
                which-key-nvim

                telescope-nvim
                telescope-fzf-native-nvim

                nvim-cmp
                lspkind-nvim
                cmp-cmdline
                cmp-path
                cmp-buffer
                cmp-nvim-lsp
        ];

        extraLuaConfig = builtins.readFile ./init.lua;
    };
}

