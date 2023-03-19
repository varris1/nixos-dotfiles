{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    globals = { };

    colorschemes.gruvbox = {
      enable = true;
      transparentBg = true;
    };

    autoCmd = [
    {
      event = [ "VimEnter" ];
      pattern = [ "*" ];
      command = "hi! Normal ctermbg=NONE guibg=NONE";
    }
    ];

    options = {
      number = true;
      ignorecase = true;
      smartcase = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      autoindent = true;
    };

    plugins = {
      intellitab.enable = true;
      airline = {
        enable = true;
        powerline = true;
        theme = "base16_gruvbox_dark_medium";
      };
      fugitive.enable = true;
      lsp.enable = true;
      nvim-autopairs.enable = true;
      nvim-colorizer.enable = true;
      nvim-lightbulb.enable = true;
      neo-tree.enable = true;
      treesitter.enable = true;
    };

    maps = {
      normal."<C-n>" = {
        silent = true;
        action = "<cmd>NeoTreeFocusToggle<CR>";
      };
    };

  };
}

