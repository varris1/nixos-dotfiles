{
  programs.beets = {
    enable = true; #until fixed

    settings = {
      plugins = "duplicates ftintitle fetchart embedart chroma edit replaygain badfiles fish";

      directory = "/mnt/hdd/Music";
      library = "/mnt/hdd/Music/library.db";
      # asciify_paths = true;

      import = {
        "write" = true;
        "resume" = true;
        "group_albums" = true;
        "move" = true;
      };

      paths = {
        "default" = "$albumartist/$year - $album%aunique{}/$track $title";
        "singleton" = "Singles/$artist/$year - $title";
        "comp" = "Compilations/$year - $album%aunique{}/$track $title";
      };

      replaygain = {
        "backend" = "gstreamer";
        "threads" = 16;
      };
    };
  };
}
