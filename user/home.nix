{ pkgs, ... }:
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
      ./configs/tmux
  ];

  home.username = "manuel";
  home.homeDirectory = "/home/manuel";
  home.packages = with pkgs; [
      appimage-run
      bc
      bottom
      calcurse
      gimp
      gnome.file-roller
      gnome.gnome-boxes
      gnome.gvfs
      gnome.seahorse
      gnome.simple-scan
      libsForQt5.dolphin
      libsForQt5.dolphin-plugins
      lutris
      mesa-demos
      nerdfonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      obs-studio
      openmw
      pavucontrol
      protontricks
      qbittorrent
      qt5ct
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
      package = pkgs.gruvbox-dark-gtk;
      name = "gruvbox-dark";
    };

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 9;
    };

    iconTheme = {
      package = pkgs.gruvbox-plus-icon-pack;
      name = "GruvboxPlus";
    };

    cursorTheme = {
      package = pkgs.capitaine-cursors-themed;
      name = "Capitaine Cursors (Gruvbox) - White";
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

  home.stateVersion = "22.05";
}

