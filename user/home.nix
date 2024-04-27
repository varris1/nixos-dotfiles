{
  config,
  pkgs,
  lib,
  inputs,
  userName,
  emailAddress,
  ...
}: {
  imports = [
    ./configs/beets
    ./configs/cava
    ./configs/dircolors.nix
    ./configs/firefox
    ./configs/fish
    ./configs/kitty
    ./configs/kvantum
    ./configs/lf
    ./configs/mpd
    ./configs/mpv
    ./configs/helix
    ./configs/rofi
    ./configs/tmux
    ./configs/wayland/hyprland
    ./configs/xdg-mime.nix

    inputs.hyprlock.homeManagerModules.hyprlock
    inputs.nix-index-database.hmModules.nix-index
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.nur.hmModules.nur
  ];

  home.username = "${userName}";
  home.homeDirectory = "/home/${userName}";
  home.packages = with pkgs; [
    alacritty
    appimage-run
    armcord
    bc
    bitwarden
    bottles
    bottom
    calcurse
    electron
    filezilla
    gimp
    gnome-multi-writer
    gnome.gnome-boxes
    gnome.gnome-settings-daemon
    gnome.gvfs
    gnome.seahorse
    gnome.simple-scan
    jq
    gnome.file-roller
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    libnotify
    mangohud
    mesa-demos
    nerdfonts
    nodejs
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    # openmw
    pamixer
    pavucontrol
    protonvpn-gui
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
    wineWowPackages.waylandFull
    winetricks
    wqy_zenhei #fix for missing non-ascii fonts in TF2
    xdg-utils
  ];

  home.sessionVariables = {
    FLAKE = "${config.home.homeDirectory}/.dotfiles";
    GTK_THEME = "${builtins.toString config.gtk.theme.name}";
    NIXOS_OZONE_WL = "1";
    NIXPKGS_ALLOW_UNFREE = "1";
    WINEDEBUG = "fixme-all";
    WINEDLLOVERRIDES = "winemenubuilder.exe=d";
  };

  fonts.fontconfig.enable = true;

  programs.bat = {
    enable = true;
  };

  programs.eza = {
    enable = true;
  };

  programs.keychain = {
    enable = true;
    enableFishIntegration = true;
  };

  services.arrpc = {
    enable = true;
  };

  services.flatpak = {
    enable = true;

    packages = [
      "dev.aunetx.deezer"
    ];

    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  services.udiskie.enable = true;

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  services.gammastep = {
    enable = true;
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
      userEmail = "${emailAddress}";
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

    rbw = {
      enable = true;
      settings = {
        pinentry = pkgs.pinentry-qt;
        email = "${emailAddress}";
      };
    };
  };

  services.gnome-keyring.enable = true;

  services.easyeffects = {
    enable = true;
    preset = "oratory1990";
  };

  services.syncthing = {
    enable = true;
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    music = "/mnt/hdd/Music";
    download = "/mnt/hdd/Downloads";
  };

  home.file."Downloads".source = config.lib.file.mkOutOfStoreSymlink "/mnt/hdd/Downloads";
  home.file."Music".source = config.lib.file.mkOutOfStoreSymlink "/mnt/hdd/Music";

  # programs.home-manager.enable = true;

  nixpkgs.config = {
    permittedInsecurePackages = [
      "nix-2.16.2" # TODO: Delete after finding out what keeps pulling this in
    ];

    allowUnfree = true;
    allowUnfreePredicate = true;
  };

  home.stateVersion = "23.11";
}
