{ config, pkgs, inputs, ... }: 
{
    programs.exa = {
        enable = true;
        enableAliases = true;
    };

    programs.fish = {
        enable = true;
        
        plugins = [
          { name = "gruvbox-theme"; src = inputs.fish-plugin-gruvbox-theme; }
          { name = "bobthefish"; src = inputs.fish-plugin-bobthefish; }
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

            ec = ''
                pushd . &> /dev/null
                cd "${config.home.homeDirectory}/.dotfiles"
                nvim "+Telescope find_files"
                popd
                '';

            nor = ''
                pushd . &> /dev/null
                cd "${config.home.homeDirectory}/.dotfiles"
                doas nixos-rebuild switch --flake .#
                popd &> /dev/null
                '';

            nou = ''
                pushd . &> /dev/null
                cd "${config.home.homeDirectory}/.dotfiles"
                nix flake update --commit-lock-file
                doas nixos-rebuild switch --upgrade --flake .#
                popd &> /dev/null
                '';
        };
        shellAliases = {
            nf = "${pkgs.neofetch}/bin/neofetch";
            e = "nvim";
        };
    };
}
