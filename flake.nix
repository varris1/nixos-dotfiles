{
  description = "My personal dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    chaotic-nyx.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

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

    aitrack = {
      url = "github:AIRLegend/aitrack";
      flake = false;
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

    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixd = {
      url = "github:nix-community/nixd";
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

    nvim-hmts = {
      url = "github:calops/hmts.nvim";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
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
          inputs.hyprland-contrib.overlays.default
          inputs.hyprpicker.overlays.default
          inputs.nixd.overlays.default
        ];
      };
    in
    {
      overlays = (import ./overlay.nix { inherit inputs; });

      nixosConfigurations.terra = nixpkgs.lib.nixosSystem
        {
          inherit system;
          inherit pkgs;
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager = {
                useUserPackages = true;
                users.manuel = import ./user/home.nix;
                extraSpecialArgs = { inherit inputs; };
                useGlobalPkgs = true;
              };
            }
            inputs.grub2-themes.nixosModules.default
            inputs.chaotic-nyx.nixosModules.default
            inputs.hyprland.nixosModules.default
          ];
        };
    };
}
