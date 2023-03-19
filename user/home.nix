{ config, pkgs, inputs, nix-colors, ... }:
{
  imports = [
    nix-colors.homeManagerModule
    ./configs/beets
    ./configs/cava
    ./configs/kakoune
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
    bottom
    calcurse
    fastfetch
    gamescope
    gimp
    gnome.file-roller
    gnome.seahorse
    gnome.simple-scan
    gnome.gvfs
    hyprpaper
    hyprpicker
    lutris
    mesa-demos
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

  programs.password-store.enable = true;

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

