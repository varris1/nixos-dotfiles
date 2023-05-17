{ config, pkgs, inputs, ... }: 
{
    programs.exa = {
        enable = true;
        enableAliases = true;
    };

    programs.fish = {
        enable = true;

        plugins = [
        ];

        interactiveShellInit = ''
            ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
        '';

        functions = {
            fish_greeting = "";

            fish_prompt = ''
                set_color -b blue
                set_color black
                printf " %s " (prompt_pwd)
                set_color -b normal
                set_color blue
                printf " "
                set_color normal
            '';

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
            e = "nvim";
        };
    };
}
