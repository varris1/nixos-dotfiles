{
  description = "My personal dotfiles";

  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic-nyx = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    eww-systray = {
      url = "github:ralismark/eww/tray-3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    nix-ld-rs = {
      url = "github:nix-community/nix-ld-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    #--- non-flakes

    fish-plugin-bobthefish = {
      url = "github:oh-my-fish/theme-bobthefish";
      flake = false;
    };

    fish-plugin-gruvbox-theme = {
      url = "github:Jomik/fish-gruvbox";
      flake = false;
    };

    gruvbox-kvantum = {
      url = "github:thefallnn/Gruvbox-Kvantum";
      flake = false;
    };

    gruvbox-plus-icon-pack = {
      url = "github:SylEleuth/gruvbox-plus-icon-pack";
      flake = false;
    };

    mygui-git = {
      url = "github:mygui/MyGUI/dae9ac4be5a09e672bec509b1a8552b107c40214";
      flake = false;
    };

    openmw-git = {
      url = "gitlab:OpenMW/openmw";
      flake = false;
    };

    xorg-git = {
      url = "gitlab:xorg/xserver?host=gitlab.freedesktop.org";
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

    #edit as you see fit
    hostName = "terra";
    userName = "manuel";
    emailAddress = "varris@posteo.net";
    flakeDir = "/home/${userName}/.dotfiles";
    #-------------------
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    overlays = import ./overlay.nix {inherit inputs;};

    nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
      inherit system;
      inherit pkgs;
      specialArgs = {
        inherit inputs;
        inherit hostName;
        inherit userName;
      };
      modules = [
        ./system/configuration.nix
        inputs.chaotic-nyx.nixosModules.default
        inputs.grub2-themes.nixosModules.default
        inputs.nur.nixosModules.nur
      ];
    };

    homeConfigurations.${userName} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs;
        inherit userName;
        inherit flakeDir;
        inherit emailAddress;
      };
      modules = [
        ./user/home.nix
        inputs.hyprlock.homeManagerModules.hyprlock
        inputs.nix-index-database.hmModules.nix-index
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
        inputs.nur.hmModules.nur
      ];
    };
  };
}
