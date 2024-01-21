{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./configs/beets
    ./configs/cava
    ./configs/dircolors.nix
    ./configs/firefox
    ./configs/fish
    ./configs/wezterm
    ./configs/kvantum
    ./configs/lf
    ./configs/mpd
    ./configs/mpv
    ./configs/helix
    ./configs/rofi
    ./configs/tmux
    ./configs/wayland/hyprland
    ./configs/xdg-mime.nix
  ];

  home.username = "manuel";
  home.homeDirectory = "/home/manuel";
  home.packages = with pkgs; [
    appimage-run
    armcord
    bc
    bitwarden
    bottles
    bottom
    calcurse
    electron
    filezilla
    gamescope
    gimp
    gnome.gnome-boxes
    gnome.gnome-settings-daemon
    gnome.gvfs
    gnome.seahorse
    gnome.simple-scan
    imv
    jq
    libsForQt5.ark
    libsForQt5.dolphin
    libsForQt5.dolphin-plugins
    lutris
    mangohud
    mesa-demos
    nerdfonts
    nodejs
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    openmw
    pamixer
    pavucontrol
    playerctl
    protontricks
    pulsemixer
    qbittorrent
    qt5ct
    samba
    signal-desktop
    sshfs
    steam-run
    steamtinkerlaunch
    thunderbird
    tldr
    twemoji-color-font
    vimv
    vulkan-tools
    wqy_zenhei #fix for missing non-ascii fonts in TF2
    xdg-utils

  ];

  home.sessionVariables = {
    GTK_THEME = "${builtins.toString config.gtk.theme.name}";
    NIXOS_OZONE_WL = "1";
    NIXPKGS_ALLOW_UNFREE = "1";
    WINEDLLOVERRIDES = "winemenubuilder.exe=d";
  };

  fonts.fontconfig.enable = true;

  programs.eza = {
    enable = true;
  };

  programs.keychain = {
    enable = true;
    enableFishIntegration = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "qt";
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
      package = pkgs.gruvbox-gtk-theme;
      name = "Gruvbox-Dark-B";
    };

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 9;
    };

    iconTheme = {
      package = pkgs.gruvbox-plus-icon-pack;
      name = "Gruvbox-Plus-Dark";
    };

    cursorTheme = {
      package = pkgs.capitaine-cursors-themed;
      name = "Capitaine Cursors (Gruvbox) - White";
      size = 32;
    };
  };

  programs = {
    aria2.enable = true;
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
    nix-index-database.comma.enable = true;

    obs-studio = {
      enable = true;
      plugins = [pkgs.obs-studio-plugins.obs-vkcapture];
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

  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
}
