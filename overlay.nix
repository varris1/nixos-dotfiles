{inputs, ...}: {
  default = final: prev: {
    gruvbox-plus-icon-pack = prev.callPackage ./pkgs/gruvbox-plus-icon-pack {inherit inputs;};
    eww-hyprland-activewindow = prev.callPackage ./pkgs/eww-hyprland-activewindow {};
    eww-hyprland-workspaces = prev.callPackage ./pkgs/eww-hyprland-workspaces {};

    # eww = final.callPackage ./pkgs/eww-systray {inherit inputs;};

    ncmpcpp = prev.ncmpcpp.override {
      visualizerSupport = true;
    };

    nerdfonts = prev.nerdfonts.override {
      fonts = ["JetBrainsMono"];
    };

    gruvbox-gtk-theme = prev.gruvbox-gtk-theme.overrideAttrs {
      patches = [./pkgs/gruvbox-gtk-theme/silence-warnings.patch];
    };

    mygui-openmw = prev.mygui.overrideAttrs (oldAttrs: {
      version = "3.4.3";
      src = inputs.mygui-git;
      patches = [];
      cmakeFlags = oldAttrs.cmakeFlags ++ ["-DMYGUI_DONT_USE_OBSOLETE=ON"]; #fix openmw link error
    });

    openmw = prev.openmw.overrideAttrs (oldAttrs: {
      version = "9999";
      src = inputs.openmw-git;
      buildInputs = (prev.lib.lists.remove prev.mygui oldAttrs.buildInputs) ++ [prev.libyamlcpp prev.luajit prev.collada-dom prev.libsForQt5.qt5.qttools final.mygui-openmw];
      cmakeFlags =
        oldAttrs.cmakeFlags
        ++ [
          "-DBUILD_BSATOOL=OFF"
          "-DBUILD_BULLETOBJECTTOOL=OFF"
          "-DBUILD_ESMTOOL=OFF"
          "-DBUILD_NIFTEST=OFF"
          "-DBUILD_OPENCS=OFF"
        ];
      patches = [];
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
