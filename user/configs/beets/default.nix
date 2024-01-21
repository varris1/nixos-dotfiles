{
  programs.beets = {
    enable = true;

    settings = {
      plugins = "duplicates ftintitle fetchart embedart chroma edit lastgenre replaygain badfiles fish";

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
        "singleton" = "$artist/$year - $title";
        "comp" = "Compilations/$year - $album%aunique{}/$track $title";
      };

      replaygain = {
        "backend" = "gstreamer";
        "threads" = 8;
      };
    };
  };
}
