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

  base16-colorschemes = pkgs.kakouneUtils.buildKakounePlugin {
    name = "base16-colorschemes";
    src = inputs.kakoune-base16-themes;
    postFixup = ''
      mkdir -p $out/share/kak/colors
      mv $out/share/kak/autoload/plugins/base16-colorschemes/colors $out/share/kak/colors
    '';
  };
in
{
  programs.kakoune = {
    enable = true;
    plugins = with pkgs.kakounePlugins; [
      base16-colorschemes
      kak-lsp
      kakboard
      kakoune-extra-filetypes
      #powerline-kak
      smarttab
      sort-selections
    ];
    config = {
      colorScheme = "base16-gruvbox-dark-medium";
      tabStop = 4;
      indentWidth = 4;
      showMatching = true;
      showWhitespace = { enable = false; };
      numberLines.enable = true;

      hooks = [
        {
          name = "WinSetOption";
          option = "filetype=nix|sh";
          commands = "hook window BufWritePre .* lsp-formatting-sync";
        }

        {
          name = "WinCreate";
          option = ".*";
          commands = "kakboard-enable";
        }
        {
          name = "InsertChar";
          option = "\\t";
          commands = "exec -draft -itersel h@";
        }
      ];

      keyMappings = [ ];

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

      # require-module powerline
      # powerline-start
      # powerline-theme gruvbox
      # powerline-separator global half-step
    '';
  };

  home.packages = [ pkgs.rnix-lsp ];
}
