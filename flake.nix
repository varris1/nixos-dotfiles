{
  description = "My personal dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";

    hyprland.url = "github:hyprwm/hyprland";
    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprpicker.url = "github:hyprwm/hyprpicker";

    gruvbox-kvantum = { url = "github:thefallnn/Gruvbox-Kvantum"; flake = false; };

    fish-plugin-bobthefish = { url = "github:oh-my-fish/theme-bobthefish"; flake = false; };
    fish-plugin-gruvbox-theme = { url = "github:Jomik/fish-gruvbox"; flake = false; };

    arrpc = { url = "github:notashelf/arrpc-flake"; inputs.nixpkgs.follows = "nixpkgs"; };
    chaotic-nyx.url = "github:chaotic-cx/nyx";
    grub2-themes = { url = "github:vinceliuice/grub2-themes"; inputs.nixpkgs.follows = "nixpkgs"; };
    openmw-git = { url = "gitlab:OpenMW/openmw"; flake = false; };
    waybar = { url = "github:alexays/waybar"; flake = false; };
    xorg-git = { url = "gitlab:xorg/xserver?host=gitlab.freedesktop.org"; flake = false; };
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
          inputs.hyprland.overlays.default
          inputs.hyprland-contrib.overlays.default
          inputs.hyprpicker.overlays.default
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
          {
            # needed to get tools working that expect a nixpkgs channel to exist
            nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
            nix.registry.nixpkgs.flake = nixpkgs;
          }
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              users.manuel = import ./user/home.nix;
              extraSpecialArgs = { inherit inputs; };
              useGlobalPkgs = true;
            };
          }
          inputs.chaotic-nyx.nixosModules.default
          inputs.grub2-themes.nixosModules.default
        ];
      };
    };
}

