{ inputs }:
{
  default = final: prev: {

    arrpc = inputs.arrpc.packages.${prev.system}.arrpc;

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

      patches = [];
      dontWrapQtApps = false;
    });

    steam = prev.steam.override {
      extraPkgs = prev: [
        prev.gnome.zenity
        prev.xdg-user-dirs
      ];
      extraLibraries = prev: [ ];
    };
    
    waybar_hyprland = prev.waybar.overrideAttrs (old: {
      version = "9999";
      src = inputs.waybar;

      preConfigure = ''
        sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' \
          src/modules/wlr/workspace_manager.cpp
      '';

      mesonFlags = old.mesonFlags ++ [ 
        "-Dexperimental=true" 
        "-Dcava=disabled"
      ];
    });

    xwayland = prev.xwayland.overrideAttrs (old: {
      version = "9999";
      src = inputs.xorg-git;
      buildInputs = old.buildInputs ++ [
        prev.udev
        prev.xorg.libpciaccess
      ];
    });
  };
}
