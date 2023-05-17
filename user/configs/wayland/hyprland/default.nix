{ config, pkgs, lib, inputs, ... }:
let
  wobsock = "/tmp/wob-vol.fifo";

  modKey = "SUPER";

  leftMonitor = "HDMI-A-1";
  rightMonitor = "DP-1";

  wallpaper = "/mnt/hdd/Wallpapers/flat-landscape-minimalism-trees-sunset-river-artwork-22750-.jpeg";

  wob-voldaemon = pkgs.writeShellScriptBin "wob-volumeindicator.sh" ''
    if pgrep "wob";  then
      killall wob &> /dev/null
    fi

    if [[ -e "${wobsock}" ]]; then
        rm "${wobsock}"
    fi

    mkfifo "${wobsock}"
    tail -f "${wobsock}" | ${pkgs.wob}/bin/wob &
    echo "wob: started"
  '';

  xwaylandSetPrimary = pkgs.writeShellScriptBin "xwayland-setprimary.sh" ''
    while true; do
    	DSP=$(${pkgs.xorg.xrandr}/bin/xrandr | awk '/2560x1440/ {print $1}' | head -n 1)
      if [[ ! -z DSP ]]; then
        ${pkgs.xorg.xrandr}/bin/xrandr --output "$DSP" --primary
      fi
      sleep 10
    done
  '';

  killprocess = pkgs.writeShellScriptBin "killprocess.sh" ''
    ps -x -o pid=,comm= | column -t -o "    " | ${pkgs.rofi}/bin/rofi -dmenu -p "kill process: " | awk '{print $1}' | uniq | xargs -r kill -9
  '';
in

{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ../waybar
    ../foot
    ../wob
    ../mako
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = lib.concatStrings [
      (builtins.readFile (inputs.catppuccin-hyprland + "/themes/macchiato.conf"))
      ''
      monitor=${leftMonitor}, 1920x1080@60, 0x0, 1
      monitor=${rightMonitor}, 2560x1440@144, 1920x0, 1

      workspace = 1, monitor:${rightMonitor}
      workspace = 2, monitor:${rightMonitor}
      workspace = 3, monitor:${rightMonitor}

      workspace = 4, monitor:${leftMonitor}
      workspace = 5, monitor:${leftMonitor}
      workspace = 6, monitor:${leftMonitor}

      input {
          kb_layout = us
          kb_variant = altgr-intl

          #mouse
          accel_profile = flat
          follow_mouse = 1
      }

      general {
          gaps_in = 16
          border_size = 4
          col.active_border = 0xff$surface2Alpha 0xff$surface0alpha 45deg
          col.inactive_border = 0xff$baseAlpha
      }

      dwindle {
          pseudotile = yes
          preserve_split = yes
      }

      master {
          new_is_master = true
      }

      misc {
          vfr = true
          vrr = 2
          enable_swallow = true
          swallow_regex = ^(foot)$
      }

      decoration {
        rounding = 10
        blur = yes
        blur_size = 3
        blur_passes = 2
        blur_new_optimizations = on

        drop_shadow = yes
        shadow_range = 8
        shadow_render_power = 1
        col.shadow = $base
      }

      animations {
        enabled = yes

        animation = windowsIn, 1, 8, default, slide
        animation = windowsOut, 1, 8, default, slide
        animation = border, 1, 8, default
        animation = fade, 1, 5, default
        animation = workspaces, 1, 4, default
      }

      exec-once = ${pkgs.openrgb}/bin/openrgb --startminimized --profile autorun.orp
      exec-once = ${pkgs.blueman}/bin/blueman-applet
      exec-once = ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator
      exec-once = ${pkgs.mullvad-vpn}/bin/mullvad-gui
      exec-once = ${xwaylandSetPrimary}/bin/xwayland-setprimary.sh
      exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1

      exec = ${wob-voldaemon}/bin/wob-volumeindicator.sh;

      #Set cursor
      exec-once = ${pkgs.hyprland}/bin/hyprctl setcursor capitaine-cursors-white 24 &> /dev/null

      exec = pkill waybar; ${pkgs.waybar_hyprland}/bin/waybar
      exec = pkill swaybg; ${pkgs.swaybg}/bin/swaybg -i ${wallpaper} -m fill

      #keybinds
      bind = ${modKey}, 1, workspace, 1
      bind = ${modKey}, 2, workspace, 2
      bind = ${modKey}, 3, workspace, 3
      bind = ${modKey}, 4, workspace, 4
      bind = ${modKey}, 5, workspace, 5
      bind = ${modKey}, 6, workspace, 6
                                
      bind = ${modKey} SHIFT, 1, movetoworkspace, 1
      bind = ${modKey} SHIFT, 2, movetoworkspace, 2
      bind = ${modKey} SHIFT, 3, movetoworkspace, 3
      bind = ${modKey} SHIFT, 4, movetoworkspace, 4
      bind = ${modKey} SHIFT, 5, movetoworkspace, 5
      bind = ${modKey} SHIFT, 6, movetoworkspace, 6


      bindm = ${modKey}, mouse:272, movewindow
      bindm = ${modKey}, mouse:273, resizewindow

      bind = ${modKey}, P, pseudo, # dwindle
      bind = ${modKey}, J, togglesplit, # dwindle
      bind = ${modKey} SHIFT, Space, togglefloating
      bind = ${modKey}, F, fullscreen

      bind = ${modKey} SHIFT, Q, killactive
      bind = ${modKey}, d, exec, ${pkgs.rofi}/bin/rofi -show drun -show-icons

      bind = ${modKey}, q, exec, ${pkgs.firefox}/bin/firefox

      bind = ${modKey}, Return, exec, ${pkgs.foot}/bin/foot

      bind = , XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 10 --get-volume > ${wobsock}
      bind = , XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 10 --get-volume > ${wobsock}

      bind = CTRL, Space, exec, ${pkgs.mako}/bin/makoctl dismiss
      bind = CTRL, grave, exec, ${pkgs.mako}/bin/makoctl restore

      bind = ${modKey} SHIFT, o, exec, ${killprocess}/bin/killprocess.sh

      bind = MOD5, F9, exec, ${pkgs.mpc-cli}/bin/mpc stop
      bind = MOD5, F10, exec, ${pkgs.mpc-cli}/bin/mpc prev
      bind = MOD5, F11, exec, ${pkgs.mpc-cli}/bin/mpc toggle
      bind = MOD5, F12, exec, ${pkgs.mpc-cli}/bin/mpc next

      bind = , Print, exec, ${pkgs.grimblast}/bin/grimblast -c --notify copy screen
      bind = ${modKey}, Print, exec, ${pkgs.grimblast}/bin/grimblast -c --notify copy active
      bind = ${modKey} SHIFT, Print, exec, ${pkgs.grimblast}/bin/grimblast -c --notify copy area
      bind = ${modKey}, R, exec, ${pkgs.dolphin}/bin/dolphin

      bind = ${modKey} SHIFT, C, exec, hyprctl reload

      layerrule = blur, waybar
      layerrule = blur, notifications

      windowrulev2 = fullscreen, class:^(hl2_linux)$
      windowrulev2 = float, class:^(org.kde.dolphin)$
    ''
    ];

  };
  home.packages = [ pkgs.wl-clipboard pkgs.wl-clipboard-x11 pkgs.hyprpicker pkgs.hyprpaper pkgs.hyprprop ];
}

