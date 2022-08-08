{
  description = "My personal dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    # Kakoune Plugins
    kakoune-smarttab.url = "github:andreyorst/smarttab.kak";
    kakoune-smarttab.flake = false;

    kakoune-auto-pairs.url = "github:alexherbo2/auto-pairs.kak";
    kakoune-auto-pairs.flake = false;

    kakoune-sort-selections.url = "github:occivink/kakoune-sort-selections";
    kakoune-sort-selections.flake = false;
    # Kakoune Plugins End

    rofi-theme.url = "github:bardisty/gruvbox-rofi";
    rofi-theme.flake = false;
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nur, ... }:
    let
      username = "manuel";
      hostname = "terra";

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
          discord = prev.discord.override {
            nss = pkgs.nss_latest;
            withOpenASAR = true;
          };
        });

      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem
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

