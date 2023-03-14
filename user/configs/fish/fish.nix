{ config, pkgs, inputs, ... }: {
  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "bobthefish";
        src = inputs.bobthefish;
      }
    ];

    interactiveShellInit = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

      set -g theme_color_scheme gruvbox
      set -g theme_nerd_fonts yes
      set -g theme_display_git_default_branch yes
      set -g theme_git_default_branches master main

    '';

    #    loginShellInit = ''
    #     if test (tty) = "/dev/tty1"
    #        ${pkgs.sway}/bin/sway &> ~/.sway.log
    #   end
    #'';

    functions = {
      #fish_prompt = ''
      # set_color green
      # printf (prompt_pwd)
      # set_color cyan
      # printf " ► "
      # set_color normal
      #'';
      fish_greeting = "";

      ec = ''
        pushd &> /dev/null
        cd "${config.home.homeDirectory}"
        set "filename" (${pkgs.fd}/bin/fd -t f . ~/.dotfiles | \
                    ${pkgs.fzf}/bin/fzf -q "$argv[1]" \
                    --preview "${pkgs.python3Packages.pygments}/bin/pygmentize -g -O linenos=1 {}")
        if test -f "$filename"
        	$EDITOR $filename
        end
        popd &> /dev/null
      '';

      nor = ''
        pushd &> /dev/null
        cd "${config.home.homeDirectory}/.dotfiles"
        doas nixos-rebuild switch --flake .#
        popd &> /dev/null
      '';

      nou = ''
        pushd &> /dev/null
        cd "${config.home.homeDirectory}/.dotfiles"
        nix flake lock --commit-lock-file --update-input nixpkgs --update-input home-manager
        doas nixos-rebuild switch --upgrade --flake .#
        popd &> /dev/null
      '';
    };
    shellAliases = {
      nf = "${pkgs.pfetch}/bin/pfetch";
    };
  };
}
