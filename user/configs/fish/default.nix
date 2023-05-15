{ config, pkgs, inputs, ... }: 
{
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
                nix flake lock --commit-lock-file --update-input nixpkgs --update-input home-manager --update-input hyprland --update-input chaotic-nyx
                doas nixos-rebuild switch --upgrade --flake .#
                popd &> /dev/null
                '';
        };
        shellAliases = {
            nf = "${pkgs.pfetch}/bin/pfetch";
            e = "${pkgs.neovim}/bin/nvim";
        };
    };
}
