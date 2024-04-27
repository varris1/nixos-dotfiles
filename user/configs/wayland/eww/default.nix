{
  pkgs,
  inputs,
  ...
}: {
  programs.eww = {
    enable = true;
    package = inputs.eww.packages.${pkgs.system}.eww;
    configDir = ./config;
  };

  home.packages = [
    pkgs.eww-hyprland-activewindow
    pkgs.eww-hyprland-workspaces
  ];
}
