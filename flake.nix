{
  description = "My personal dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nur, ... }:
    let
      username = "manuel";

      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [ self.overlays.default nur.overlay ];
      };

    in
    {
      overlays.default =
        (final: prev: rec {
          nerdfonts = prev.nerdfonts.override {
            fonts = [
              "JetBrainsMono"
            ];
          };
        });

      nixosConfigurations.terra = nixpkgs.lib.nixosSystem
        {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./system/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager =
                {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${username} = import ./user/home.nix;
                  extraSpecialArgs = {
                    inherit inputs;
                    inherit pkgs;
                  };
                };
            }
          ];
        };
    };
}

