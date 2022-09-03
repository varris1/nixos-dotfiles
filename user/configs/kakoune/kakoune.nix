{ config, pkgs, lib, inputs, ... }:
let
  smarttab = pkgs.kakouneUtils.buildKakounePlugin {
    name = "kakoune-smarttab";
    src = inputs.kakoune-smarttab;
  };

  sort-selections = pkgs.kakouneUtils.buildKakounePlugin {
    name = "sort-selections-kak";
    src = inputs.kakoune-sort-selections;
  };

in
{
  programs.kakoune = {
    enable = true;
    plugins = with pkgs.kakounePlugins; [
      smarttab
      kakboard
      #auto-pairs-kak
      kak-lsp
      sort-selections
      powerline-kak
      kakoune-extra-filetypes
    ];
    config = {
      colorScheme = "gruvbox-dark";
      tabStop = 4;
      indentWidth = 4;
      showMatching = true;
      showWhitespace = {
        enable = false;
      };
      numberLines.enable = true;

      hooks = [
        { name = "WinSetOption"; option = "filetype=nix|sh"; commands = "hook window BufWritePre .* lsp-formatting-sync"; }

        { name = "WinCreate"; option = ".*"; commands = "kakboard-enable"; }
        { name = "InsertChar"; option = "\\t"; commands = "exec -draft -itersel h@"; }
      ];

      keyMappings = [
      ];

      ui = {
        assistant = "none";
        setTitle = true;
      };

    };
    extraConfig = ''
      set global startup_info_version 99999999
      #set-option global auto_pairs ( ) { } [ ] '"' '"' "'" "'" ` ` “ ” ‘ ’ « » ‹ ›

      eval %sh{kak-lsp --kakoune -s $kak_session}  # Not needed if you load it with plug.kak.
      lsp-enable

      map global user l %{: enter-user-mode lsp<ret>} -docstring "LSP mode"

      require-module powerline
      powerline-start
      powerline-theme gruvbox
      powerline-separator global half-step
    '';
  };

  home.packages = [
    pkgs.rnix-lsp
  ];
}

