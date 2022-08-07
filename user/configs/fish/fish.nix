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
        	set "filename" (${pkgs.fd}/bin/fd -t f . ${config.home.homeDirectory}/.config/nixpkgs | \
        	            ${pkgs.fzf}/bin/fzf -q "$argv[1]" \
        	            --preview "${pkgs.python3Packages.pygments}/bin/pygmentize -g -O linenos=1 {}")
        	if test -f "$filename"
        		$EDITOR $filename
        	end
        	popd &> /dev/null
      '';
    };
    shellAliases = {
      hm = "home-manager";
      nf = "${pkgs.neofetch}/bin/neofetch";
    };
  };
}

