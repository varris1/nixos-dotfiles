{pkgs, ...}: {
  xdg.configFile."lf/icons".source = ./icons;

  programs.lf = {
    enable = true;

    settings = {
      drawbox = true;
      icons = true;
      ignorecase = true;
      preview = true;
      sixel = true;
    };
  };
}
