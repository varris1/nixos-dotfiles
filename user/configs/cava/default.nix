{
  pkgs,
  lib,
  ...
}: {
  home.packages = [pkgs.cava];

  xdg.configFile."cava/config".text = lib.generators.toINI {} {
    general = {
      bars = "0";
      bar_width = "2";
    };

    input = {
      method = "fifo";
      source = "/tmp/mpd.fifo";
      sample_rate = "44100";
      sample_bits = "16";
    };
  };
}
