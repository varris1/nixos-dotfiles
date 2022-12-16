{ config, pkgs, inputs, nix-colors, ... }: {
  imports = [
    nix-colors.homeManagerModule
    ./configs/beets/beets.nix
    ./configs/kakoune/kakoune.nix
    ./configs/wayland/sway.nix
    ./configs/fish/fish.nix
    ./configs/mpd/mpd.nix
    ./configs/mpv/mpv.nix
    ./configs/firefox/firefox.nix
    ./configs/nnn/nnn.nix
    ./configs/dircolors.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "manuel";
  home.homeDirectory = "/home/manuel";
  home.packages = [
    pkgs.appimage-run
    pkgs.discord-canary
    pkgs.gamescope
    pkgs.gnome.file-roller
    pkgs.gnome.gvfs
    pkgs.gnome.nautilus
    pkgs.lutris
    pkgs.mesa-demos
    pkgs.nerdfonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-cjk-serif
    pkgs.obs-studio
    pkgs.pass
    pkgs.pavucontrol
    pkgs.protontricks
    pkgs.signal-desktop
    pkgs.sshfs
    pkgs.steam
    pkgs.steam-run
    pkgs.sxiv
    pkgs.thunderbird
    pkgs.twemoji-color-font
    pkgs.wineWowPackages.stagingFull
    pkgs.xivlauncher
    pkgs.vulkan-validation-layers
  ];

  home.sessionVariables = {
    BROWSER = "firefox";
    EDITOR = "kak";
    #GTK_USE_PORTAL = "1";
    WINEDLLOVERRIDES = "winemenubuilder.exe=d";
    WLR_RENDERER = "vulkan"; #Causes hangs
  };

  colorScheme = nix-colors.colorSchemes.gruvbox-dark-medium;

  fonts.fontconfig.enable = true;

  programs.keychain = {
    enable = true;
    enableFishIntegration = true;
  };

  services.gpg-agent = { enable = true; };

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

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Varris";
    userEmail = "varris@posteo.net";
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.command-not-found.enable = false;
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  services.gnome-keyring.enable = true;
  services.easyeffects = {
    enable = true;
    preset = "custom";
  };

  programs.aria2.enable = true;

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

