{ config, pkgs, ... }:
{
    programs.mpv = {
        enable = true;
        config = {
            profile = "gpu-hq";
            ytdl-format = "bestvideo+bestaudio";
            hwdec = "vaapi-copy";
            gpu-context = "wayland";
            force-window = "yes";
        };
    };
}
