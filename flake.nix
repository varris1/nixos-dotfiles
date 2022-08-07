{
  description = "My personal dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nur, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [ self.overlays.default ];
      };


      lib = nixpkgs.lib;

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

      nixosConfigurations.terra = lib.nixosSystem
        {
          inherit system;
          specialArgs = inputs;
          modules = [
            ./system/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager =
                {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.manuel = import ./user/home.nix;
                  extraSpecialArgs = { inherit pkgs; };
                };
            }
            nur.nixosModules.nur
          ];
        };
    };
}

