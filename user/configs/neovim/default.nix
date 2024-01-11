{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      bufferline-nvim
      comment-nvim
      dressing-nvim
      gruvbox-nvim
      hmts-nvim
      indent-blankline-nvim
      lualine-nvim
      luasnip
      mini-nvim
      neo-tree-nvim
      noice-nvim
      nui-nvim
      nvim-autopairs
      nvim-colorizer-lua
      nvim-notify
      nvim-surround
      nvim-ufo
      nvim-web-devicons
      smart-splits-nvim
      vim-easy-align
      which-key-nvim
      presence-nvim

      vim-fugitive

      telescope-nvim
      telescope-fzf-native-nvim
      telescope-ui-select-nvim
      telescope-undo-nvim

      null-ls-nvim
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      trouble-nvim

      nvim-cmp
      cmp-buffer
      cmp-cmdline
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-path
      cmp_luasnip
      friendly-snippets
      lspkind-nvim
    ];

    extraPackages = with pkgs; [
      nodePackages.bash-language-server
      clang-tools
      lua-language-server
      python3Packages.jedi-language-server
      nixpkgs-fmt
      nixd
      rust-analyzer
      stylua
      nodePackages.typescript-language-server
      nodePackages.vscode-css-languageserver-bin
      zls
    ];
  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
