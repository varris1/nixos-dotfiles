{ config, pkgs, lib, ... }:
let
  smarttab = pkgs.kakouneUtils.buildKakounePlugin {
    name = "smarttab-kak";
    src = pkgs.fetchFromGitHub {
      owner = "andreyorst";
      repo = "smarttab.kak";
      rev = "86ac6599b13617ff938905ba4cdd8225d7eb6a2e";
      sha256 = "1992xwf2aygzfd26lhg3yiy253g0hl1iagj0kq9yhcqg0i5xjcj9";
    };
  };
  auto-pairs = pkgs.kakouneUtils.buildKakounePlugin {
    name = "auto-pairs-kak";
    src = pkgs.fetchFromGitHub {
      owner = "alexherbo2";
      repo = "auto-pairs.kak";
      rev = "bfdcb8566076f653ec707f86207f83ea75173ce9";
      sha256 = "0vx9msk8wlj8p9qf6yiv9gzrbanb5w245cidnx5cppgld2w842ij";
    };
  };
  sort-selections = pkgs.kakouneUtils.buildKakounePlugin {
    name = "sort-selections-kak";
    src = pkgs.fetchFromGitHub {
      owner = "occivink";
      repo = "kakoune-sort-selections";
      rev = "fdc03616b83140d3657f971dbc914269f9c8f1ff";
      sha256 = "P0uyuKQ//QqzOHs920gggXUKyWoMeAWn7XnlOQazHbc=";
    };
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
