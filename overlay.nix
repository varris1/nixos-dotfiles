{inputs, ...}: {
  default = final: prev: {
    gruvbox-plus-icon-pack = final.callPackage ./pkgs/gruvbox-plus-icon-pack {inherit inputs;};

    ncmpcpp = prev.ncmpcpp.override {
      visualizerSupport = true;
    };

    nerdfonts = prev.nerdfonts.override {
      fonts = ["JetBrainsMono"];
    };

    # mygui = prev.mygui.overrideAttrs (old: {
    #   version = "3.4.3";
    #   src = inputs.mygui-git;
    #   patches = [];
    # });
    #
    # openmw = prev.openmw.overrideAttrs (old: {
    #   version = "9999";
    #   src = inputs.openmw-git;
    #
    #   buildInputs = old.buildInputs ++ [prev.libyamlcpp prev.luajit prev.collada-dom];
    #
    #   patches = [];
    #   dontWrapQtApps = false;
    # });

    steam = prev.steam.override {
      extraPkgs = prev: [
        prev.libkrb5
        prev.keyutils
        prev.gnome.zenity
        prev.xdg-user-dirs
      ];
      extraLibraries = prev: [
        prev.gperftools
        prev.mpg123
      ];
    };

    nvim-hmts = prev.vimUtils.buildVimPlugin {
      pname = "nvim-hmts";
      version = "1";
      src = inputs.nvim-hmts;
    };
  };
}
