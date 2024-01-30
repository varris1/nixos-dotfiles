{
  config,
  pkgs,
  inputs,
  flakeDir,
  ...
}: {
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "gruvbox-theme";
        src = inputs.fish-plugin-gruvbox-theme;
      }
      {
        name = "bobthefish";
        src = inputs.fish-plugin-bobthefish;
      }
    ];

    interactiveShellInit = ''
      theme_gruvbox dark medium
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

      set -g theme_color_scheme gruvbox
      set -g theme_nerd_fonts yes
      set -g theme_display_git_default_branch yes
      set -g theme_git_default_branches master main
    '';

    functions = {
      fish_greeting = "";

      nor = ''
        doas nixos-rebuild switch --flake ${flakeDir}
      '';

      hms = ''
        home-manager switch --flake ${flakeDir}
      '';

      nou = ''
        nix flake update ${flakeDir} --commit-lock-file
        doas nixos-rebuild switch --upgrade --flake ${flakeDir}
      '';
    };
    shellAliases = {
      ec = "hx ${flakeDir}";
      nf = "${pkgs.fastfetch}/bin/fastfetch";
      ls = "${pkgs.eza}/bin/eza --icons";
      ll = "${pkgs.eza}/bin/eza --icons -l";
      r = "${pkgs.lf}/bin/lf";
    };
  };
}
