{ config, lib, pkgs, ... }:

let
    cfg = config.services.mpd-notification;
in {
    meta.maintainers = [ "Varris" ];

    options.services.mpd-notification = {
        package = lib.mkPackageOption pkgs "mpd-notification" { };
        enable = lib.mkEnableOption "the mpd-notification service";
    };

    config = lib.mkIf cfg.enable {
        systemd.user.services.mpd-notification = {
            Unit = {
                Description = "A notification daemon for MPD";
                Documentation = "https://github.com/eworm-de/mpd-notification";
                After = [ "mpd.service" "network.target" "network-online.target" ];
                Requires = [ "dbus.socket" ];
            };

            Service = {
                Type = "simple";
                Restart = "on-failure";
                ExecStart = "${cfg.package}/bin/mpd-notification";
            };
        };
    };
}
