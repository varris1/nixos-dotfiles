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

    # Fish Plugins
    bobthefish = {
      url = "github:oh-my-fish/theme-bobthefish";
      flake = false;
    };
    # Fish Plugins End

    # Kakoune Plugins
    kakoune-smarttab = {
      url = "github:andreyorst/smarttab.kak";
      flake = false;
    };

    kakoune-sort-selections = {
      url = "github:occivink/kakoune-sort-selections";
      flake = false;
    };
    # Kakoune Plugins End

    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    friendly-snippets = {
      url = "github:rafamadriz/friendly-snippets";
      flake = false;
    };

    xorg-git = {
      url = "gitlab:xorg/xserver?host=gitlab.freedesktop.org";
      flake = false;
    };

    mesa-git = {
      url = "gitlab:mesa/mesa?host=gitlab.freedesktop.org";
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

    waybar = {
      url = "github:alexays/waybar";
      flake = false;
    };

    webcord = {
      url = "github:fufexan/webcord-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    openmw = {
      url = "gitlab:OpenMW/openmw";
      flake = false;
    };

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
          inputs.hyprland-contrib.overlays.default
          inputs.hyprpaper.overlays.default
          inputs.hyprpicker.overlays.default
          inputs.webcord.overlays.default
        ];
      };
    in
    {
      overlays.default = final: prev: rec {
        nerdfonts = prev.nerdfonts.override {
          fonts = [ "JetBrainsMono" "IBMPlexMono" ];
        };

        waybar = prev.waybar.overrideAttrs (old: {
          version = "git";
          src = inputs.waybar;

          preConfigure = ''
            sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
          '';

          mesonFlags = old.mesonFlags ++ [ "-Dexperimental=true" ];

        });

        xwayland = prev.xwayland.overrideAttrs (old: {
          version = "git";

          src = inputs.xorg-git;
          buildInputs = old.buildInputs ++ [
            prev.udev
            prev.xorg.libpciaccess
          ];
        });

        steam = prev.steam.override {
          extraPkgs = pkgs: [
            pkgs.gnome.zenity
          ];
        };

        ncmpcpp = prev.ncmpcpp.override {
          visualizerSupport = true;
        };

        mesa-git =
          (prev.mesa.overrideAttrs
            (old: {
              version = "git";
              src = inputs.mesa-git;
              patches = [
                ./pkgs/mesa-git/disk_cache-include-dri-driver-path-in-cache-key.patch
                ./pkgs/mesa-git/opencl.patch
              ];
              mesonFlags = old.mesonFlags ++ [
                "-Dandroid-libbacktrace=disabled"
                "-Dlmsensors=disabled"
                "-Dlibunwind=disabled"
                "-Dgallium-xa=disabled"
              ];
            })).override
            {
              galliumDrivers = [ "radeonsi" "swrast" ];
              vulkanDrivers = [ "amd" ];
              enableGalliumNine = false; # Replaced by DXVK
            };

        customedid = pkgs.callPackage ./pkgs/custom-edid { };
        wxedid = pkgs.callPackage ./pkgs/wxedid { };
        fastfetch = pkgs.callPackage ./pkgs/fastfetch { };
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
            ./system/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                users.manuel = import ./user/home.nix;
                extraSpecialArgs = { inherit inputs pkgs nix-colors; };
              };
            }
            inputs.grub2-themes.nixosModules.default
          ];
        };
    };
}

