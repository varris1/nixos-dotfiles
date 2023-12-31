{
  description = "My personal dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    chaotic-nyx.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/hyprland";
    hyprland-contrib.url = "github:hyprwm/contrib";

    ags.url = "github:Aylur/ags";

    eww-systray.url = "github:ralismark/eww/tray-3";
    eww-systray.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    gruvbox-kvantum.url = "github:thefallnn/Gruvbox-Kvantum";
    gruvbox-kvantum.flake = false;

    fish-plugin-bobthefish.url = "github:oh-my-fish/theme-bobthefish";
    fish-plugin-bobthefish.flake = false;

    fish-plugin-gruvbox-theme.url = "github:Jomik/fish-gruvbox";
    fish-plugin-gruvbox-theme.flake = false;

    gruvbox-plus-icon-pack.url = "github:SylEleuth/gruvbox-plus-icon-pack";
    gruvbox-plus-icon-pack.flake = false;

    openmw-git.url = "gitlab:OpenMW/openmw";
    openmw-git.flake = false;

    mygui-git.url = "github:mygui/MyGUI/dae9ac4be5a09e672bec509b1a8552b107c40214";
    mygui-git.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;

      config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
        permittedInsecurePackages = [
        ];
      };

      overlays = [
        self.overlays.default
      ];
    };
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    overlays = import ./overlay.nix {inherit inputs;};

    nixosConfigurations.terra =
      nixpkgs.lib.nixosSystem
      {
        inherit system;
        inherit pkgs;
        specialArgs = {inherit inputs;};
        modules = [
          ./system/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              users.manuel = import ./user/home.nix;
              extraSpecialArgs = {
                inherit inputs;
                inherit system;
              };
              useGlobalPkgs = true;
            };
          }
          inputs.chaotic-nyx.nixosModules.default
          inputs.nur.nixosModules.nur
        ];
      };
  };
}
