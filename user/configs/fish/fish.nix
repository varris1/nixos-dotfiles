{ config, pkgs, ... }:
{
  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
    '';
    functions = {
      fish_prompt = ''
        set_color green
        printf (prompt_pwd)
        set_color cyan
        printf " ► "
        set_color normal
      '';
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
        nix flake lock --commit-lock-file --update-input nixpkgs --update-input home-manager --update-input nur
        doas nixos-rebuild switch --upgrade --flake .#
        popd &> /dev/null
      '';
    };
    shellAliases = {
      nf = "${pkgs.neofetch}/bin/neofetch";
      r = "${pkgs.nnn}/bin/nnn";
    };
  };
}

