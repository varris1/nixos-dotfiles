{
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [
    ../ags
    ./settings.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
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
    Exec=swww img "%f" && ln -sf "%f" ~/.cache/swww/wallpaper
  '';

  home.packages = [
    inputs.hyprland-contrib.packages.${system}.hyprprop
    pkgs.hyprpicker
    pkgs.swww
    pkgs.wl-clipboard
    pkgs.wl-clipboard-x11
  ];
}
