{
  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq";
      ytdl-format = "bestvideo+bestaudio";
      hwdec = "vaapi";
      force-window = "yes";
      ao = "pipewire";
    };
  };
}
