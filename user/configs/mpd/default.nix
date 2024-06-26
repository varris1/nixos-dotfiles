{pkgs, ...}: {
  imports = [
    ../../modules/mpd-notification
  ];

  services.mpd = {
    enable = true;
    musicDirectory = "/mnt/hdd/Music";
    extraConfig = ''
      auto_update "yes"
      restore_paused "yes"

      replaygain "track"

      audio_output {
          type "pipewire"
          name "MPD PipeWire"
      }

      audio_output {
          type "fifo"
          name "my_fifo"
          path "/tmp/mpd.fifo"
          format "44100:16:2"
      }

      audio_output {
          type "httpd"
          name "FLAC Stream"
          encoder "flac"
          bitrate "128000"
          port "8000"
          format "44100:16:2"
          always_on "yes"
      }
    '';
  };

  services.mpd-discord-rpc = {
    enable = true;
    settings = {
      id = 474605546457137157;
      hosts = ["localhost:6600"];
      format = {
        details = "$title ($album)";
        state = "by $artist";
        timestamp = "elapsed";
        large_image = "mpd_large";
        small_image = "";
        large_text = "Music Player Daemon";
        small_text = "";
      };
    };
  };

  programs.ncmpcpp = {
    enable = true;

    settings = {
      lyrics_fetchers = "musixmatch, sing365, metrolyrics, justsomelyrics, jahlyrics, plyrics, tekstowo, zeneszoveg, internet";

      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "my_fifo";
      visualizer_in_stereo = true;
      visualizer_type = "spectrum";
      visualizer_look = "▮●";

      mouse_support = false;

      ask_before_clearing_playlists = false;

      user_interface = "alternative";
      alternative_header_first_line_format = "$5{%a}$0";
      alternative_header_second_line_format = "$7{%t}|{%f}$0";
      progressbar_look = "─╼ ";

      song_columns_list_format = "(25)[5]{a:artist} (3f)[5]{n: } (50)[cyan]{t|f:title} (5)[cyan]{lr:duration}";
      playlist_display_mode = "columns";
      browser_display_mode = "columns";
      search_engine_display_mode = "columns";
      playlist_editor_display_mode = "columns";

      colors_enabled = true;
      discard_colors_if_item_is_selected = true;

      main_window_color = "yellow";
      visualizer_color = "yellow";
      header_window_color = "yellow";
    };
  };

  services.mpd-mpris = {
    enable = true;
    mpd.useLocal = true;
  };

  services.mpd-notification = {
    enable = true;
  };

  home.packages = [pkgs.mpc-cli];
}
