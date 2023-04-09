{ config, pkgs, inputs, nix-colors, ... }:
let 
colors = config.colorScheme.colors;
in 
{
  imports = [
    nix-colors.homeManagerModule
      ./configs/beets
      ./configs/cava
      ./configs/wayland/hyprland.nix
      #./configs/wayland/sway.nix
      ./configs/fish
      ./configs/mpd
      ./configs/mpv
      ./configs/neovim
      ./configs/firefox
      ./configs/dircolors.nix
      ./configs/xdg-mime.nix
  ];

# Home Manager needs a bit of information about you and the
# paths it should manage.
  home.username = "manuel";
  home.homeDirectory = "/home/manuel";
  home.packages = with pkgs; [
    appimage-run
      qt5ct
      bc
      bottom
      calcurse
      fastfetch
      gimp
      gnome.file-roller
      gnome.gvfs
      gnome.seahorse
      gnome.simple-scan
      lutris
      mesa-demos
      nerdfonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      obs-studio
      pavucontrol
      protontricks
      sc-im
      signal-desktop
      sshfs
      steam
      steam-run
      steamtinkerlaunch
      sxiv
      thunderbird
      tldr
      twemoji-color-font
      vimv
      vulkan-tools
      vulkan-validation-layers
      webcord
      wineWowPackages.stagingFull
      wxedid
      xdg-utils
      xivlauncher
      ];

  home.sessionVariables = {
    EDITOR = "nvim";
    WINEDLLOVERRIDES = "winemenubuilder.exe=d";
    RADV_PERFTEST = "gpl";
    NIXOS_OZONE_WL = "1";

    XDG_SCREENSHOTS_DIR = "~/Screenshots";
  };

  colorScheme = nix-colors.colorSchemes.gruvbox-dark-medium;

  fonts.fontconfig.enable = true;

  programs.keychain = {
    enable = true;
    enableFishIntegration = true;
  };

  services.gpg-agent.enable = true;

  services.udiskie.enable = true;

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  services.gammastep = {
    enable = false;
    provider = "geoclue2";
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.gruvbox-dark-gtk;
      name = "gruvbox-dark";
    };

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 9;
    };

    iconTheme = {
      package = pkgs.gruvbox-dark-icons-gtk;
      name = "oomox-gruvbox-dark";
    };

    cursorTheme = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors-white";
      size = 32;
    };

  };
  programs = {
    aria2.enable = true;
    password-store.enable = true;
    command-not-found.enable = false;

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    git = {
      enable = true;
      lfs.enable = true;
      userName = "Varris";
      userEmail = "varris@posteo.net";
    };

    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };

    zellij = {
      enable = true;
      settings = {
        theme = "gruvbox-dark";
        themes.gruvbox-dark = {
          fg = "#${colors.base05}";
          bg = "#${colors.base00}";
          black = "#${colors.base01}";
          red = "#${colors.base08}";
          green = "#${colors.base0B}";
          yellow = "#${colors.base0A}";
          blue = "#${colors.base0D}";
          magenta = "#${colors.base0E}";
          cyan = "#${colors.base0C}";
          white = "#${colors.base07}";
          orange = "#${colors.base0F}";
        };
      };
    };
  };

  services.gnome-keyring.enable = true;
  services.easyeffects = {
    enable = false;
    preset = "custom";
  };


  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    music = "/mnt/hdd/Music";
    download = "/mnt/hdd/Downloads";
  };
# This value determines the Home Manager release that your
# configuration is compatible with. This helps avoid breakage
# when a new Home Manager release introduces backwards
# incompatible changes.
#
# You can update Home Manager without changing this value. See
# the Home Manager release notes for a list of state version
# changes in each release.
  home.stateVersion = "22.05";
}

