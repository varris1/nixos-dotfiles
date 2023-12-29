{
  config,
  pkgs,
  ...
}: let
  leftMonitor = {
    display = "DP-2";
    res = "preferred";
    pos = "0x0";
  };

  rightMonitor = {
    display = "DP-1";
    res = "preferred";
    pos = "2560x0";
  };

  modKey = "SUPER";
in {
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        "${leftMonitor.display}, ${leftMonitor.res}, ${leftMonitor.pos}, 1"
        "${rightMonitor.display}, ${rightMonitor.res}, ${rightMonitor.pos}, 1"
      ];

      workspace = [
        "1, monitor:${rightMonitor.display}, persistent:true"
        "2, monitor:${rightMonitor.display}, persistent:true"
        "3, monitor:${rightMonitor.display}, persistent:true"

        "4, monitor:${leftMonitor.display}, persistent:true"
        "5, monitor:${leftMonitor.display}, persistent:true"
        "6, monitor:${leftMonitor.display}, persistent:true"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "altgr-intl";
        accel_profile = "flat";
        follow_mouse = 1;
      };

      general = {
        gaps_in = 10;
        border_size = 4;
        "col.active_border" = "rgba(665C54ff)";
        "col.inactive_border" = "rgba(282828ff)";
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_is_master = true;
      };

      misc = {
        force_default_wallpaper = 0;
        vfr = true;
        vrr = 2;
      };

      decoration = {
        rounding = 10;

        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          new_optimizations = true;
        };
        drop_shadow = true;
        shadow_range = 30;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };

      exec-once = [
        "${pkgs.openrgb}/bin/openrgb --startminimized --profile autorun.orp"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "${pkgs.ydotool}/bin/ydotoold"
      ];

      exec = [
        "${pkgs.xorg.xrandr}/bin/xrandr --output ${rightMonitor.display} --primary"
        "ags -q; sleep 1; ags"
        "sleep 2; pkill swww-daemon; swww init"

        #Set cursor
        "${pkgs.hyprland}/bin/hyprctl setcursor '${config.gtk.cursorTheme.name}' ${builtins.toString config.gtk.cursorTheme.size} &> /dev/null"
      ];

      env = [
        "XCURSOR_SIZE,${builtins.toString config.gtk.cursorTheme.size}"
      ];

      bind = [
        "${modKey}, 1, workspace, 1"
        "${modKey}, 2, workspace, 2"
        "${modKey}, 3, workspace, 3"
        "${modKey}, 4, workspace, 4"
        "${modKey}, 5, workspace, 5"
        "${modKey}, 6, workspace, 6"

        "${modKey} SHIFT, 1, movetoworkspace, 1"
        "${modKey} SHIFT, 2, movetoworkspace, 2"
        "${modKey} SHIFT, 3, movetoworkspace, 3"
        "${modKey} SHIFT, 4, movetoworkspace, 4"
        "${modKey} SHIFT, 5, movetoworkspace, 5"
        "${modKey} SHIFT, 6, movetoworkspace, 6"

        "${modKey}, P, pseudo, # dwindle"
        "${modKey}, J, togglesplit, # dwindle"
        "${modKey} SHIFT, Space, togglefloating"
        "${modKey}, F, fullscreen"

        "${modKey} SHIFT, Q, killactive"
        "${modKey}, D, exec, ${pkgs.rofi-wayland}/bin/rofi -show drun -p Applications -show-icons"
        "${modKey} SHIFT, P, exec, ${pkgs.rofi-pass-wayland}/bin/rofi-pass"

        "${modKey}, Q, exec, ${pkgs.firefox}/bin/firefox"

        "${modKey}, Return, exec, ${pkgs.kitty}/bin/kitty"

        ", XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5 --get-volume"
        ", XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5 --get-volume"

        "CTRL, grave, exec, ags toggle-window notification-center"

        "MOD5, F9, exec, ${pkgs.playerctl}/bin/playerctl stop"
        "MOD5, F10, exec, ${pkgs.playerctl}/bin/playerctl previous"
        "MOD5, F11, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        "MOD5, F12, exec, ${pkgs.playerctl}/bin/playerctl next"
        ", Print, exec, ${pkgs.grimblast}/bin/grimblast -c --notify copy screen"
        "${modKey}, Print, exec, ${pkgs.grimblast}/bin/grimblast -c --notify copy active"
        "${modKey} SHIFT, Print, exec, ${pkgs.grimblast}/bin/grimblast -c --notify copy area"
        "${modKey}, R, exec, ${pkgs.dolphin}/bin/dolphin"
        "${modKey} SHIFT, C, exec, hyprctl reload"
      ];

      bindm = [
        "${modKey}, mouse:272, movewindow"
        "${modKey}, mouse:273, resizewindow"
      ];

      layerrule = [
        "blur, notifications"
        "ignorezero, notifications"
        "blur, gtk-layer-shell"
        "blur, bar-0"
        "blur, bar-1"
        "blur, notificationPopupWindow"
        "ignorezero, notificationPopupWindow"
      ];

      windowrulev2 = [
        "fullscreen, class:^(hl2_linux)$"
        "float, class:^(org.kde.dolphin)$"
      ];
    };
  };
}
