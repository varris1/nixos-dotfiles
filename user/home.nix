{
  config,
  pkgs,
  inputs,
  ...
}: {
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
    inputs.nix-index-database.hmModules.nix-index
  ];

  home.username = "manuel";
  home.homeDirectory = "/home/manuel";
  home.packages = with pkgs; [
    appimage-run
    bc
    bottles
    bottom
    calcurse
    discord
    electron
    gamescope_git
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
    ranger
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
    vulkan-validation-layers
    xdg-utils
    xivlauncher
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    GTK_THEME = "${builtins.toString config.gtk.theme.name}";
    MESA_DISK_CACHE_SINGLE_FILE = "1";
    NIXOS_OZONE_WL = "1";
    NIXPKGS_ALLOW_UNFREE = "1";
    RADV_PERFTEST = "gpl";
    WINEDLLOVERRIDES = "winemenubuilder.exe=d";
    XDG_SCREENSHOTS_DIR = "~/Screenshots";
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

  home.stateVersion = "23.05";
}
