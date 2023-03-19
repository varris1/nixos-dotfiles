{ config, pkgs, ... }: {
  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq";
      ytdl-format = "bestvideo+bestaudio";
      hwdec = "vaapi";
      #     gpu-context = "wayland";
      force-window = "yes";
      ao = "pipewire";
      #      vo = "dmabuf-wayland";
    };
  };
}
