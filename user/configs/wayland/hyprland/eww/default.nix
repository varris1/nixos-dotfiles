{
  pkgs,
  inputs,
  ...
}: {
  programs.eww = {
    enable = false;
    package = inputs.eww-systray.packages.${pkgs.system}.eww-wayland;
    configDir = ./config;
  };
}
