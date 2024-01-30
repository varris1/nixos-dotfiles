{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq";
      ytdl-format = "bestvideo+bestaudio";
      hwdec = "vaapi";
      force-window = "yes";
      ao = "pipewire";
      video-sync = "display-resample";
    };

    scripts = with pkgs.mpvScripts; [
      quality-menu
      uosc
      sponsorblock
      thumbfast
    ];
  };
}
