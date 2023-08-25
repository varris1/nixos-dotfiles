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
      vim-easy-align
      mini-nvim

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
      nodePackages.vscode-css-languageserver-bin
      zls
    ] ++ [
      pkgs.nvim-hmts
    ];
  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
