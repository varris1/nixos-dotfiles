{ config, pkgs, lib, inputs, ... }:
let
  smarttab = pkgs.kakouneUtils.buildKakounePlugin {
    name = "kakoune-smarttab";
    src = inputs.kakoune-smarttab;
  };

  auto-pairs = pkgs.kakouneUtils.buildKakounePlugin {
    name = "kakoune-auto-pairs";
    src = inputs.kakoune-auto-pairs;
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
      auto-pairs
      pkgs.kak-lsp
      sort-selections
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
      set-option global auto_pairs ( ) { } [ ] '"' '"' "'" "'" ` ` “ ” ‘ ’ « » ‹ ›

      eval %sh{kak-lsp --kakoune -s $kak_session}  # Not needed if you load it with plug.kak.
      lsp-enable

      map global user l %{: enter-user-mode lsp<ret>} -docstring "LSP mode"

    '';
  };

  home.packages = [
    pkgs.rnix-lsp
  ];
}

