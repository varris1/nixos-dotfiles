{ config, pkgs, ... }: {
  programs.dircolors = {
    enable = true;
    enableFishIntegration = true;
  };
}

