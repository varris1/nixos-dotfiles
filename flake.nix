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

    rofi-theme = {
      url = "github:bardisty/gruvbox-rofi";
      flake = false;
    };

    wayland-protcols-git = {
      url = "gitlab:wayland/wayland-protocols?host=gitlab.freedesktop.org";
      flake = false;
    };

    xorg-git = {
      url = "gitlab:xorg/xserver?host=gitlab.freedesktop.org";
      flake = false;
    };

    mesa-git = {
      url = "gitlab:mesa/mesa/mesa-22.3.2?host=gitlab.freedesktop.org";
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

    waybar = {
      url = "github:alexays/waybar";
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
        overlays = [ self.overlays.default ];
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
            pkgs.gamescope
            pkgs.gnome.zenity
            pkgs.keyutils
            pkgs.libkrb5
            pkgs.mangohud
            pkgs.mpg123
          ];

          extraLibraries = pkgs: [
            pkgs.mpg123
            pkgs.zlib-ng
          ];
        };

        mesa-git = (prev.mesa.overrideAttrs (old: {
          version = "git";
          src = inputs.mesa-git;
          buildInputs = old.buildInputs ++ [ pkgs.llvmPackages.libclang pkgs.glslang pkgs.vulkan-loader ];
          patches = [
            ./pkgs/patches/mesa-git/opencl.patch
            ./pkgs/patches/mesa-git/disk_cache-include-dri-driver-path-in-cache-key.patch
          ];
          mesonFlags = pkgs.lib.lists.remove
            "-Dxvmc-libs-path=${placeholder "drivers"}/lib"
            old.mesonFlags; # xvmc was removed upstream
        })).override {
          galliumDrivers = [ "radeonsi" "swrast" ];
          vulkanDrivers = [ "amd" ];
          enableGalliumNine = false; # Replaced by DXVK
        };

        customedid = pkgs.callPackage ./pkgs/custom-edid { };
        wxedid = pkgs.callPackage ./pkgs/wxedid { };

      };

      nixosConfigurations.terra = nixpkgs.lib.nixosSystem {
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
          inputs.grub2-themes.nixosModule
        ];
      };
    };
}
