{ config, pkgs, inputs, ... }:
let
  leftMonitor = {
    display = "DP-2";
    res = "2560x1440";
    pos = "-2560x0";
    refreshRate = "144";
  };

  rightMonitor = {
    display = "DP-1";
    res = "2560x1440";
    pos = "0x0";
    refreshRate = "144";
  };

  modKey = "SUPER";

  wobsock = "/tmp/wob-vol.fifo";

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

  killprocess = pkgs.writeShellScriptBin "killprocess.sh" ''
    ps -x -o pid=,comm= | column -t -o "  " | ${pkgs.rofi-wayland}/bin/rofi -dmenu -p "kill process: " | awk '{print $1}' | uniq | xargs -r kill -9
  '';

  passmenu = pkgs.writeShellScriptBin "passmenu.sh" ''
    shopt -s nullglob globstar

    prefix=''${PASSWORD_STORE_DIR-~/.password-store}
    password_files=( "$prefix"/**/*.gpg )
    password_files=( "''${password_files[@]#"$prefix"/}" )
    password_files=( "''${password_files[@]%.gpg}" )

    password=$(printf '%s\n' "''${password_files[@]}" | ${pkgs.rofi-wayland}/bin/rofi -dmenu -p "pass: " "$@")

    [[ -n $password ]] || exit

    pass show -c "$password" 2>/dev/null
  '';

in

{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ../ags
    ../foot
    ../wob
    ../mako
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      monitor=${leftMonitor.display}, ${leftMonitor.res}@${leftMonitor.refreshRate}, ${leftMonitor.pos}, 1
      monitor=${rightMonitor.display}, ${rightMonitor.res}@${rightMonitor.refreshRate}, ${rightMonitor.pos}, 1

      workspace = 1, monitor:${rightMonitor.display}
      workspace = 2, monitor:${rightMonitor.display}
      workspace = 3, monitor:${rightMonitor.display}

      workspace = 4, monitor:${leftMonitor.display}
      workspace = 5, monitor:${leftMonitor.display}
      workspace = 6, monitor:${leftMonitor.display}

      input {
          kb_layout = us
          kb_variant = altgr-intl

          #mouse
          accel_profile = flat
          follow_mouse = 1
      }

      general {
          gaps_in = 10
          border_size = 4
          col.active_border = rgba(665C54ff)
          col.inactive_border = rgba(282828ff)
      }

      dwindle {
          pseudotile = yes
          preserve_split = yes
      }

      master {
          new_is_master = true
      }

      misc {
          disable_hyprland_logo = true
          disable_splash_rendering = true
          vfr = true
          vrr = 2
          # enable_swallow = true
          # swallow_regex = ^(foot)$
      }

      decoration {
        rounding = 10

        blur {
          enabled = yes
          size = 3
          passes = 2
          new_optimizations = on
        }

        drop_shadow = yes
        shadow_range = 8
        shadow_render_power = 1
        col.shadow = rgba(282828ff)
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
      exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
      # exec-once = ${pkgs.mullvad-vpn}/bin/mullvad-gui
      exec-once = ${pkgs.ydotool}/bin/ydotoold

      exec = ${pkgs.xorg.xrandr}/bin/xrandr --output ${rightMonitor.display} --primary
      exec = ${wob-voldaemon}/bin/wob-volumeindicator.sh
      exec = ags -q; ags
      exec = pkill swww; sleep 2 && ${pkgs.swww}/bin/swww init && ${pkgs.swww}/bin/swww img $(cat ~/.cache/swww/wallpaper.txt)

      #Set cursor
      exec = ${pkgs.hyprland}/bin/hyprctl setcursor "${config.gtk.cursorTheme.name}" ${builtins.toString config.gtk.cursorTheme.size} &> /dev/null

      # Fix clipboard with Wine
      exec-once = ${pkgs.wl-clipboard}/bin/wl-paste -t text -w sh -c '[ "$(${pkgs.xclip}/bin/xclip -selection clipboard -o)" = "$(${pkgs.wl-clipboard}/bin/wl-paste -n)" ] || ${pkgs.xclip}/bin/xclip -selection clipboard'

      env = XCURSOR_SIZE,${builtins.toString config.gtk.cursorTheme.size}

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
      bind = ${modKey}, D, exec, ${pkgs.rofi-wayland}/bin/rofi -show drun -p Applications -show-icons

      bind = ${modKey}, Q, exec, ${pkgs.firefox}/bin/firefox

      bind = ${modKey}, Return, exec, ${pkgs.foot}/bin/foot

      bind = , XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 10 --get-volume > ${wobsock}
      bind = , XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 10 --get-volume > ${wobsock}

      bind = CTRL, Space, exec, ${pkgs.mako}/bin/makoctl dismiss
      bind = CTRL, grave, exec, ${pkgs.mako}/bin/makoctl restore
      bind = ${modKey} SHIFT, O, exec, ${killprocess}/bin/killprocess.sh
      bind = ${modKey} SHIFT, P, exec, ${passmenu}/bin/passmenu.sh

      bind = MOD5, F9, exec, ${pkgs.mpc-cli}/bin/mpc stop
      bind = MOD5, F10, exec, ${pkgs.mpc-cli}/bin/mpc prev
      bind = MOD5, F11, exec, ${pkgs.mpc-cli}/bin/mpc toggle
      bind = MOD5, F12, exec, ${pkgs.mpc-cli}/bin/mpc next

      bind = , Print, exec, ${pkgs.grimblast}/bin/grimblast -c --notify copy screen
      bind = ${modKey}, Print, exec, ${pkgs.grimblast}/bin/grimblast -c --notify copy active
      bind = ${modKey} SHIFT, Print, exec, ${pkgs.grimblast}/bin/grimblast -c --notify copy area
      bind = ${modKey}, R, exec, ${pkgs.dolphin}/bin/dolphin

      bind = ${modKey} SHIFT, C, exec, hyprctl reload

      layerrule = blur, notifications
      layerrule = ignorezero, notifications

      layerrule = blur, gtk-layer-shell
      layerrule = blur, bar-0
      layerrule = blur, bar-1


      windowrulev2 = fullscreen, class:^(hl2_linux)$
      windowrulev2 = float, class:^(org.kde.dolphin)$
    '';
  };

  home.file.".local/share/kservices5/swww.desktop".text = ''
    [Desktop Entry]
    Type=Service
    X-KDE-ServiceTypes=KonqPopupMenu/Plugin
    MimeType=image/jpeg;image/png;image/svg
    Actions=setSWWWWallpaper;
    Encoding=UTF-8

    [Desktop Action setSWWWWallpaper]
    Name=Set Image as Wallpaper
    Exec=swww img "%f" && echo "%f" > ~/.cache/swww/wallpaper.txt
  '';

  home.packages = [ pkgs.wl-clipboard pkgs.wl-clipboard-x11 pkgs.hyprpicker pkgs.swww pkgs.hyprprop ];
}

