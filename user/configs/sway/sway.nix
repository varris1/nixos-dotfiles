{ config, pkgs, lib, inputs, ... }:
let
  wobsock = "/tmp/wob-swayvol.fifo";
  wallpaper = "/mnt/hdd/Wallpapers/gruv-4.jpg";

  left_monitor = "HDMI-A-1";
  right_monitor = "DP-1";

  wob-voldaemon = pkgs.writeShellScriptBin "wob-volumedaemon.sh" ''
    if pgrep "wob";  then
      killall wob &> /dev/null
    fi

    if [[ -e "${wobsock}" ]]; then
        rm "${wobsock}"
    fi

    mkfifo "${wobsock}"
    tail -f "${wobsock}" | ${pkgs.wob}/bin/wob --border-color "#D65D0EFF" --background-color "#282828FF" --bar-color "#D65D0EFF" -b 2 -H 40  &
    echo "wob: started"
  '';

  passmenu = pkgs.writeShellScriptBin "passmenu.sh" ''
    shopt -s nullglob globstar

    prefix=''${PASSWORD_STORE_DIR-~/.password-store}
    password_files=( "$prefix"/**/*.gpg )
    password_files=( "''${password_files[@]#"$prefix"/}" )
    password_files=( "''${password_files[@]%.gpg}" )

    password=$(printf '%s\n' "''${password_files[@]}" | ${pkgs.rofi-wayland}/bin/rofi -dmenu -p "pass" "$@")

    [[ -n $password ]] || exit

    pass show -c "$password" 2>/dev/null
  '';

  xwaylandSetPrimary = pkgs.writeShellScriptBin "xwayland-setprimary.sh" ''
    DSP=$(${pkgs.xorg.xrandr}/bin/xrandr | awk '/2560x1440/ {print $1}' | head -n 1)

    ${pkgs.xorg.xrandr}/bin/xrandr --output "$DSP" --primary
    echo "Xwayland: $DSP - Primary monitor set"
  '';

  rofi-theme = inputs.rofi-theme + "/gruvbox-dark.rasi";

  killprocess = pkgs.writeShellScriptBin "killprocess.sh" ''
    ps -x -o pid=,comm= | column -t -o "    " | rofi -dmenu  -p "kill process" | awk '{print $1}' | uniq | xargs -r kill -9
  '';
in {
  imports = [ ./waybar.nix ];
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "${pkgs.foot}/bin/foot";
      gaps = { inner = 20; };
      keybindings =
        let modifier = config.wayland.windowManager.sway.config.modifier;
        in lib.mkOptionDefault {
          "XF86AudioRaiseVolume" =
            "exec ${pkgs.pamixer}/bin/pamixer -i 10 --get-volume > ${wobsock}";
          "XF86AudioLowerVolume" =
            "exec ${pkgs.pamixer}/bin/pamixer -d 10 --get-volume > ${wobsock}";
          "Mod5+F9" = "exec  ${pkgs.mpc-cli}/bin/mpc stop";
          "Mod5+F11" = "exec ${pkgs.mpc-cli}/bin/mpc toggle";
          "Mod5+F10" = "exec ${pkgs.mpc-cli}/bin/mpc prev";
          "Mod5+F12" = "exec ${pkgs.mpc-cli}/bin/mpc next";
          "XF86AudioMute" = "exec mpc toggle";

          "Print" =
            "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot -c --notify copy screen";
          "${modifier}+Shift+Print" =
            "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot -c --notify copy area";
          "${modifier}+Print" =
            "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot -c --notify copy active";

          "${modifier}+d" = "exec ${pkgs.rofi-wayland}/bin/rofi -show drun";
          "${modifier}+Shift+p" = "exec ${passmenu}/bin/passmenu.sh";
          "${modifier}+Shift+o" = "exec ${killprocess}/bin/killprocess.sh";

          "${modifier}+q" = "exec ${pkgs.firefox}/bin/firefox";
          "${modifier}+r" = "exec ${pkgs.xfce.thunar}/bin/thunar";

          "Ctrl+Space" = "exec ${pkgs.mako}/bin/makoctl dismiss";
          "Ctrl+grave" = "exec ${pkgs.mako}/bin/makoctl restore";
        };
      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_variant = "altgr-intl";
        };
        "type:pointer" = { accel_profile = "flat"; };
        "type:touchpad" = {
          events =
            "disabled"; # disable DualSense touchpad. Let Steam Input handle it
        };
      };
      output = {
        "*" = { bg = "${wallpaper} stretch"; };
        "${left_monitor}" = { position = "0 0"; };
        "${right_monitor}" = {
          position = "1920 0";
          adaptive_sync = "on";
        };
      };

      workspaceOutputAssign = [
        {
          workspace = "1";
          output = "${right_monitor}";
        }
        {
          workspace = "2";
          output = "${right_monitor}";
        }
        {
          workspace = "3";
          output = "${right_monitor}";
        }

        {
          workspace = "4";
          output = "${left_monitor}";
        }
        {
          workspace = "5";
          output = "${left_monitor}";
        }
        {
          workspace = "6";
          output = "${left_monitor}";
        }
      ];

      startup = [
        {
          command = "${wob-voldaemon}/bin/wob-volumedaemon.sh";
          always = true;
        }
        {
          command = "${xwaylandSetPrimary}/bin/xwayland-setprimary.sh";
          always = true;
        }
        {
          command = "${pkgs.autotiling}/bin/autotiling";
          always = true;
        }
        {
          command =
            "${pkgs.openrgb}/bin/openrgb --server --profile autorun.orp";
        }
        { command = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"; }
      ];
      bars = [{ command = "${pkgs.waybar}/bin/waybar"; }];
      colors = {
        focused = {
          border = "#d65d0e";
          background = "#d65d0e";
          text = "#eeeeec";
          indicator = "#d65d0e";
          childBorder = "#d65d0e";
        };
        unfocused = {
          border = "#323232";
          background = "#323232";
          text = "#babdb6";
          indicator = "#323232";
          childBorder = "#323232";
        };
        focusedInactive = {
          border = "#323232";
          background = "#323232";
          text = "#babdb6";
          indicator = "#323232";
          childBorder = "#323232";
        };
        urgent = {
          border = "#000000";
          background = "#000000";
          text = "#eeeeec";
          indicator = "#323232";
          childBorder = "#323232";
        };
      };
    };
    extraConfig = ''
      seat seat0 xcursor_theme capitaine-cursors-white 32
    '';
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
    '';
    wrapperFeatures = { gtk = true; };
  };

  programs.mako = {
    enable = true;
    anchor = "top-right";
    defaultTimeout = 5000;

    width = 320;
    height = 130;

    backgroundColor = "#282828";
    borderColor = "#3C3836";
    borderRadius = 10;
    borderSize = 2;

    font = "JetBrainsMono Nerd Font Regular 9";
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = "${rofi-theme}";
    font = "JetBrainsMono Nerd Font Regular 9";
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:pixelsize=12";
        box-drawings-uses-font-glyphs = "yes";
        pad = "16x16 center";
      };

      colors = {
        alpha = "0.95";
        background = "282828";
        foreground = "ebdbb2";
        regular0 = "282828";
        regular1 = "cc241d";
        regular2 = "98971a";
        regular3 = "d79921";
        regular4 = "458588";
        regular5 = "b16286";
        regular6 = "689d6a";
        regular7 = "a89984";
        bright0 = "928374";
        bright1 = "fb4934";
        bright2 = "b8bb26";
        bright3 = "fabd2f";
        bright4 = "83a598";
        bright5 = "d3869b";
        bright6 = "8ec07c";
        bright7 = "ebdbb2";

        selection-foreground = "000000";
        selection-background = "FFFACD";
        urls = "0087BD";
      };
    };
  };

  home.packages = [ pkgs.wl-clipboard ];
}
