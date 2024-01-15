{inputs, ...}: {
  default = final: prev: {
    gruvbox-plus-icon-pack = prev.callPackage ./pkgs/gruvbox-plus-icon-pack {inherit inputs;};
    eww-hyprland-activewindow = prev.callPackage ./pkgs/eww-hyprland-activewindow {};
    eww-hyprland-workspaces = prev.callPackage ./pkgs/eww-hyprland-workspaces {};
    bitwarden-rofi = prev.callPackage ./pkgs/bitwarden-rofi {rofi = prev.rofi-wayland;};

    ncmpcpp = prev.ncmpcpp.override {
      visualizerSupport = true;
    };

    nerdfonts = prev.nerdfonts.override {
      fonts = ["JetBrainsMono"];
    };

    gruvbox-gtk-theme = prev.gruvbox-gtk-theme.overrideAttrs {
      patches = [./pkgs/gruvbox-gtk-theme/silence-warnings.patch];
    };

    mygui-openmw = prev.mygui.overrideAttrs (old: {
      version = "3.4.3";
      src = inputs.mygui-git;
      patches = [];
      cmakeFlags = old.cmakeFlags ++ ["-DMYGUI_DONT_USE_OBSOLETE=ON"]; #fix openmw link error
    });

    openmw = prev.openmw.overrideAttrs (old: {
      version = "9999";
      src = inputs.openmw-git;
      buildInputs = (prev.lib.lists.remove prev.mygui old.buildInputs) ++ [prev.libyamlcpp prev.luajit prev.collada-dom final.mygui-openmw];
      patches = [];
    });

    kitty = prev.kitty.overrideAttrs (old: {
      patches = [./pkgs/kitty/0011-fix-test_fish_integration.patch];
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

    vimPlugins =
      prev.vimPlugins
      // {
        presence-nvim = prev.vimUtils.buildVimPlugin {
          name = "presence";
          src = inputs.nvim-presence;
        };
      };
  };
}
