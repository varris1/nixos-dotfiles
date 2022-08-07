{ config, pkgs, ... }: {

  programs.beets = {
    enable = true;

    settings = {
      plugins = "mpdupdate ftintitle fetchart chroma edit";

      directory = "/mnt/hdd/Music";
      library = "/mnt/hdd/Music/library.db";

      import = {
        "resume" = true;
        "group_albums" = true;
        "move" = true;
      };

      paths = {
        "default" = "%asciify{$albumartist}/$year - %asciify{$album}%aunique{}/$track %asciify{$title}";
        "singleton" = "Non-Album/%asciify{$artist}/%asciify{$title}";
        "comp" = "Compilations/%asciify{$album}%aunique{}/$track %asciify{$title}";
      };

      ftintitle = {
        "auto" = true;
      };

      fetchart = {
        "auto" = true;
      };

      chroma = {
        auto = true;
      };

      replaygain = {
        "backend" = "gstreamer";
        "threads" = 8;
      };
    };

  };
}

