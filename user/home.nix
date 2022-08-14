{ config, pkgs, inputs, ... }:

{
  imports = [
    ./configs/beets/beets.nix
    ./configs/kakoune/kakoune.nix
    ./configs/sway/sway.nix
    ./configs/fish/fish.nix
    ./configs/mpd/mpd.nix
    ./configs/mpv/mpv.nix
    ./configs/firefox/firefox.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "manuel";
  home.homeDirectory = "/home/manuel";
  home.packages = [
    pkgs.appimage-run
    pkgs.bottles
    pkgs.discord
    pkgs.firefox
    pkgs.nerdfonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-cjk-serif
    pkgs.pass
    pkgs.pavucontrol
    pkgs.polymc
    pkgs.steam
    pkgs.steam-run
    pkgs.thunderbird
    pkgs.twemoji-color-font
    pkgs.xivlauncher
  ];

  home.sessionVariables = {
    EDITOR = "kak";
    GTK_USE_PORTAL = "1";
  };

  fonts.fontconfig.enable = true;

  services.gpg-agent = {
    enable = true;
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

  programs.aria2.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    music = "/mnt/hdd/Music";
    download = "/mnt/hdd/Downloads";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "thunar.desktop" ];
    };
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

