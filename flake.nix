{
  description = "My personal dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = {
      url = "github:Misterio77/nix-colors";
    };

    bobthefish = {
      url = "github:oh-my-fish/theme-bobthefish";
      flake = false;
    };

    friendly-snippets = {
      url = "github:rafamadriz/friendly-snippets";
      flake = false;
    };

    xorg-git = {
      url = "gitlab:xorg/xserver?host=gitlab.freedesktop.org";
      flake = false;
    };

    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/hyprland";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    openmw-git = {
      url = "gitlab:OpenMW/openmw";
      flake = false;
    };

    waybar = {
      url = "github:alexays/waybar";
      flake = false;
    };

    gruvbox-kvantum = {
      url = "github:thefallnn/Gruvbox-Kvantum";
      flake = false;
    };

    chaotic-nyx.url = "github:chaotic-aur/nyx";

    #catppuccin theme repos
    catppuccin-hyprland = { url = "github:catppuccin/hyprland"; flake = false; };

  };

  outputs = { self, nixpkgs, home-manager, nix-colors, ... }@inputs:
    let
    system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
    overlays = [
      self.overlays.default
        inputs.chaotic-nyx.overlays.default
        inputs.hyprland.overlays.default
        inputs.hyprland-contrib.overlays.default
        inputs.hyprpaper.overlays.default
        inputs.hyprpicker.overlays.default
    ];
  };
  in
  {
    overlays.default = final: prev: rec {
      nerdfonts = prev.nerdfonts.override {
        fonts = [ "JetBrainsMono" ];
      };

      xwayland = prev.xwayland.overrideAttrs (old: {
          version = "9999";
          src = inputs.xorg-git;
          buildInputs = old.buildInputs ++ [
          prev.udev
          prev.xorg.libpciaccess
          ];
          });

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

      steam = prev.steam.override {
        extraPkgs = pkgs: [
          pkgs.gnome.zenity
            pkgs.xdg-user-dirs
        ];
        extraLibraries = pkgs: [
        ];
      };

      openmw = prev.openmw.overrideAttrs (old: {
          version = "9999";
          src = inputs.openmw-git;

          buildInputs = old.buildInputs ++ [ pkgs.libyamlcpp pkgs.luajit ];

          patches = [];
          dontWrapQtApps = false;
          });

      ncmpcpp = prev.ncmpcpp.override {
        visualizerSupport = true;
      };

      catppuccin-kvantum-macchiato = prev.catppuccin-kvantum.override {
        accent = "Blue";
        variant = "Macchiato";
      };

      catppuccin-papirus-folders-macchiato = prev.catppuccin-papirus-folders.override {
        accent = "blue";
        flavor = "macchiato";
      };

    };

    nixosConfigurations.terra = nixpkgs.lib.nixosSystem
    {
      inherit system;
      inherit pkgs;
      specialArgs = { inherit inputs; };
      modules = [
      {
# needed to get tools working that expect a nixpkgs channel to exist
        nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
        nix.registry = { nixpkgs.flake = nixpkgs; };
      }
      ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useUserPackages = true;
            users.manuel = import ./user/home.nix;
            extraSpecialArgs = { inherit inputs pkgs nix-colors; };
          };
        }
      inputs.grub2-themes.nixosModules.default
        inputs.chaotic-nyx.nixosModules.default
      ];
    };
  };
}

