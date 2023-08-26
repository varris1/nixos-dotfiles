{ inputs, ... }:
{
  default = final: prev: {

    eww-hyprland-activewindow = prev.callPackage ./pkgs/eww-hyprland-activewindow { inherit inputs; };

    gruvbox-plus-icon-pack = final.callPackage ./pkgs/gruvbox-plus-icon-pack { };

    ncmpcpp = prev.ncmpcpp.override {
      visualizerSupport = true;
    };

    nerdfonts = prev.nerdfonts.override {
      fonts = [ "JetBrainsMono" ];
    };

    openmw = prev.openmw.overrideAttrs (old: {
      version = "9999";
      src = inputs.openmw-git;

      buildInputs = old.buildInputs ++ [ prev.libyamlcpp prev.luajit ];

      patches = [ ];
      dontWrapQtApps = false;
    });

    steam = prev.steam.override {
      extraPkgs = prev: [
        prev.libkrb5
        prev.keyutils
        prev.gnome.zenity
        prev.xdg-user-dirs

      ];
      extraLibraries = prev: [ ];
    };

    nvim-hmts = prev.vimUtils.buildVimPluginFrom2Nix {
      pname = "nvim-hmts";
      version = "1";
      src = inputs.nvim-hmts;
    };
  };
}
