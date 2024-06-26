{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../eww
    ../mako
    ./settings.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    #package = inputs.nixpkgs.legacyPackages.${pkgs.system}.hyprland;
  };

  home.file.".local/share/kservices5/swww.desktop".text = ''
    [Desktop Entry]
    Type=Service
    X-KDE-ServiceTypes=KonqPopupMenu/Plugin
    MimeType=image/jpeg;image/png;image/svg
    Actions=setSWWWWallpaper;
    Encoding=UTF-8

    [Desktop Action setSWWWWallpaper]
    Name=Set Image as Wallpaper
    Exec=swww img "%f"
  '';

  home.packages = [
    pkgs.hyprpicker
    pkgs.swww
    pkgs.wl-clipboard
    pkgs.wl-clipboard-x11
  ];
}
