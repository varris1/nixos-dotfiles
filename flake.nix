{
  description = "My personal dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic-nyx = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
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

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gruvbox-kvantum = {
      url = "github:thefallnn/Gruvbox-Kvantum";
      flake = false;
    };

    fish-plugin-bobthefish = {
      url = "github:oh-my-fish/theme-bobthefish";
      flake = false;
    };

    fish-plugin-gruvbox-theme = {
      url = "github:Jomik/fish-gruvbox";
      flake = false;
    };

    nixd = {
      url = "github:nix-community/nixd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-hmts = {
      url = "github:calops/hmts.nvim";
      flake = false;
    };

    gruvbox-plus-icon-pack = {
      url = "github:SylEleuth/gruvbox-plus-icon-pack";
      flake = false;
    };

    openmw-git = {
      url = "gitlab:OpenMW/openmw";
      flake = false;
    };

    mygui-git = {
      url = "github:mygui/MyGUI/dae9ac4be5a09e672bec509b1a8552b107c40214";
      flake = false;
    };
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
        ];
      };
  };
}
