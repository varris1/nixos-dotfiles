{
  description = "My personal dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    wlroots-git = {
      url = "git+https://gitlab.freedesktop.org/wlroots/wlroots.git";
      flake = false;
    };

    sway-git = {
      url = "github:swaywm/sway";
      flake = false;
    };

    gamescope-git = {
      url = "github:Plagman/gamescope";
      flake = false;
    };

    xorg-git = {
      url = "git+https://gitlab.freedesktop.org/xorg/xserver.git";
      flake = false;
    };

    mesa-git = {
      url = "git+https://gitlab.freedesktop.org/mesa/mesa.git";
      flake = false;
    };

    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    veloren = {
      url = "github:veloren/veloren";
    };

  };

  outputs = { self, nixpkgs, home-manager, veloren, ... }@inputs:
    let
      username = "manuel";
      hostname = "terra";

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
      overlays.default = (final: prev: rec {

        nerdfonts = prev.nerdfonts.override {
          fonts = [
            "JetBrainsMono"
          ];
        };

        wlroots-git = prev.wlroots.overrideAttrs (old: {
          version = "0.16.0";
          src = inputs.wlroots-git;
        });

        sway-unwrapped = (prev.sway-unwrapped.overrideAttrs (old: {
          version = "1.8";
          buildInputs = old.buildInputs ++ [
            prev.xorg.xcbutilwm
            prev.pcre2
          ];
          nativeBuildInputs = old.nativeBuildInputs ++ [
            prev.cmake
          ];
          src = inputs.sway-git;
        })).override { wlroots = wlroots-git; };

        waybar = prev.waybar.override {
          wlroots = wlroots-git;
        };

        # xwayland = prev.xwayland.overrideAttrs (old: {
        #   version = "22.2";
        #   src = inputs.xorg-git;
        #   buildInputs = old.buildInputs ++ [
        #     prev.udev
        #     prev.xorg.libpciaccess
        #   ];
        # });

        steam = prev.steam.override {
          extraPkgs = pkgs: [
            pkgs.gnome.zenity
            pkgs.gamescope
            pkgs.libkrb5
            pkgs.keyutils
          ];
        };

        gamescope = prev.gamescope.overrideAttrs (old: {
          version = "3.11.45";
          src = inputs.gamescope-git;
        });

        mesa-git = (prev.mesa.overrideAttrs (old: {
          version = "23.0";
          src = inputs.mesa-git;
          buildInputs = old.buildInputs ++ [
            pkgs.glslang
          ];
          patches = [
            ./pkgs/mesa-git/opencl.patch
            ./pkgs/mesa-git/disk_cache-include-dri-driver-path-in-cache-key.patch
          ];
        })).override {
          galliumDrivers = [ "radeonsi" "swrast" ];
          vulkanDrivers = [ "amd" ];
          enableGalliumNine = false; # Replaced by DXVK
        };

        inherit (veloren.packages."${system}") veloren-voxygen;

      });

      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem
        {
          inherit system;
          inherit pkgs;
          specialArgs = { inherit inputs; };
          modules = [
            {
              #needed to get tools working that expect a nixpkgs channel to exist
              nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
              nix.registry = {
                nixpkgs.flake = nixpkgs;
              };
            }
            ./system/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                #useGlobalPkgs = true;
                useUserPackages = true;
                users.${username} = import ./user/home.nix;
                extraSpecialArgs = {
                  inherit inputs pkgs;
                };
              };
            }
            inputs.grub2-themes.nixosModule
          ];
        };
    };
}

