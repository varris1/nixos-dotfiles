{inputs, ...}: {
  default = final: prev: {
    gruvbox-plus-icon-pack = final.callPackage ./pkgs/gruvbox-plus-icon-pack {inherit inputs;};

    ncmpcpp = prev.ncmpcpp.override {
      visualizerSupport = true;
    };

    nerdfonts = prev.nerdfonts.override {
      fonts = ["JetBrainsMono"];
    };

    kitty = prev.kitty.overrideAttrs (old: {
      patches = old.patches ++ [./pkgs/kitty/0011-fix-test_fish_integration.patch];
    });

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
  };
}
