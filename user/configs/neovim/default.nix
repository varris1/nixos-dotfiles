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

      lsp.servers = {
        clangd.enable = true;
        rnix-lsp.enable = true;
        bashls.enable = true;
      };

      comment-nvim.enable = true;

      fugitive.enable = true;
      lsp.enable = true;
      nvim-autopairs.enable = true;

      lspkind = {
        enable = true;
        cmp = {
          enable = true;
        };
      };

      cmp-treesitter.enable = true;

      luasnip = {
        enable = true;
        fromVscode = [
          { paths = inputs.friendly-snippets.outPath; }
        ];
      };

      cmp_luasnip.enable = true; 

      nvim-cmp = {
        enable = true; 

        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip";}
          { name = "path"; }
          { name = "buffer"; }
          { name = "grammar"; } 
        ];

        mappingPresets = [ "insert" ];
        mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
        };

        completion = {
          # keywordLength = 5;
        };

        window.completion = {
          border = "single"; 
          scrollbar = true;
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None";
        };

        window.documentation = {
          border = "single";
          maxHeight = "math.floor(40 * (40 / vim.o.lines))";
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None";
        };

      };

      nvim-colorizer.enable = true;
      nvim-lightbulb.enable = true;

      neo-tree.enable = true;

      treesitter = {
        enable = true;
        indent = true;
      };
    };

    maps = {
      normal."<C-n>" = {
        silent = true;
        action = "<cmd>NeoTreeFocusToggle<CR>";
      };
    };

  };
}
