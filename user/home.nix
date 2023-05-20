{ config, pkgs, inputs, nix-colors, ... }:
{
  imports = [
      ./configs/beets
      ./configs/cava
      ./configs/wayland/hyprland
      ./configs/rofi
      ./configs/fish
      ./configs/mpd
      ./configs/mpv
      ./configs/neovim
      ./configs/firefox
      ./configs/dircolors.nix
      ./configs/xdg-mime.nix
      ./configs/kvantum
      ./configs/zellij.nix
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
      libsForQt5.dolphin
      libsForQt5.dolphin-plugins
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
      openxray
      openmw
      pavucontrol
      protontricks
      sc-im
      signal-desktop
      sshfs
      steam-run
      sxiv
      thunderbird
      tldr
      twemoji-color-font
      vimv
      vulkan-tools
      vulkan-validation-layers
      webcord-vencord
      wineWowPackages.stagingFull
      xdg-utils
      xivlauncher
      qbittorrent
      ];

  home.sessionVariables = {
    EDITOR = "nvim";
    MESA_DISK_CACHE_SINGLE_FILE = "1";
    NIXOS_OZONE_WL = "1";
    NIXPKGS_ALLOW_UNFREE = "1";
    RADV_PERFTEST = "gpl";
    WINEDLLOVERRIDES = "winemenubuilder.exe=d";
    XDG_SCREENSHOTS_DIR = "~/Screenshots";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  fonts.fontconfig.enable = true;

  programs.keychain = {
    enable = true;
    enableFishIntegration = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gtk2";
  };

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
      package = pkgs.catppuccin-gtk-macchiato;
      name = "Catppuccin-Macchiato-Standard-Lavender-Dark";
    };

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 9;
    };

    iconTheme = {
      package = pkgs.catppuccin-papirus-folders-macchiato;
      name = "Papirus";
    };

    cursorTheme = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors-white";
      size = 24;
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
  };

  services.gnome-keyring.enable = true;
  services.easyeffects = {
    enable = true;
    preset = "DT770";
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

