{inputs, ...}: {
  default = final: prev: {
    gruvbox-plus-icon-pack = final.callPackage ./pkgs/gruvbox-plus-icon-pack {inherit inputs;};

    ncmpcpp = prev.ncmpcpp.override {
      visualizerSupport = true;
    };

    nerdfonts = prev.nerdfonts.override {
      fonts = ["JetBrainsMono"];
    };

    openmw = prev.openmw.overrideAttrs (old: {
      version = "9999";
      src = inputs.openmw-git;

      buildInputs = old.buildInputs ++ [prev.libyamlcpp prev.luajit];

      patches = [];
      dontWrapQtApps = false;
    });

    steam = prev.steam.override {
      extraPkgs = prev: [
        prev.libkrb5
        prev.keyutils
        prev.gnome.zenity
        prev.xdg-user-dirs
      ];
      extraLibraries = prev: [];
    };

    nvim-hmts = prev.vimUtils.buildVimPlugin {
      pname = "nvim-hmts";
      version = "1";
      src = inputs.nvim-hmts;
    };
  };
}
