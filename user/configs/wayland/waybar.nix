{ config, pkgs, ... }:
let
  colors = config.colorScheme.colors;

  ds-battery = pkgs.writeShellScriptBin "ds-battery.sh" ''
    ds_capacity_file="/sys/class/power_supply/ps-controller-battery-4c:b9:9b:74:ae:31/capacity"
    ds_status_file="/sys/class/power_supply/ps-controller-battery-4c:b9:9b:74:ae:31/status"

    while true; do
    	if [[ -f $ds_capacity_file ]]; then
    		charge=$(<"$ds_capacity_file")
    		if [[ $(<"$ds_status_file") == "Charging" ]]; then
    			echo "{\"class\":\"charging\",\"text\":\"  Charging: $charge%\",\"tooltip\":\"Charging:\n$charge%\"}"
    		else
    			echo "{\"class\":\"discharging\",\"text\":\"  $charge%\",\"tooltip\":\"Battery:\\n$charge%\"}"
    		fi
    	else
    		echo "{\"class\":\"not_connected\",\"text\":\"\"}"
    	fi
    	sleep 1
    done
  '';
in
{
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 32;

      modules-left = [ "custom/blank" "hyprland/window" ];
      modules-center = [ "wlr/workspaces" "custom/blank" ];
      modules-right = [
        "custom/ds-battery"
        "pulseaudio"
        "mpd"
        "tray"
        "custom/blank"
        "clock"
        "custom/blank"
      ];

      "sway/mode" = { format = " {}"; };
      "sway/window" = {
        icon = false;
        icon-size = 16;
      };

      "wlr/workspaces" = {
        on-click = "activate";
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";

        format = "{icon}";
        format-icons = {
          #active = "";
          #default = "";
          active = "";
          default = "";
        };
      };

      "custom/workspaceborderleft" = {
        format = " ";
      };

      "custom/workspaceborderright" = {
        format = " ";
      };

      "hyprland/window" = {
        separate-outputs = true;
      };

      "clock" = {
        format = "{:%a %d. %B  %H:%M}";
      };

      "pulseaudio" = {
        scroll-step = 5;
        format = "{icon} {volume}%";
        format-icons = [ "" "" "墳" "" ];
        ignored-sinks = [ "Easy Effects Sink" ];
      };

      "tray" = {
        icon-size = 16;
        spacing = 10;
      };
      "mpd" = {
        format =
          "{stateIcon} {artist} - {title}  {elapsedTime:%M:%S}/{totalTime:%M:%S}";
        format-stopped = "栗 stopped";
        state-icons = {
          playing = "";
          paused = "";
        };
      };

      "custom/ds-battery" = {
        return-type = "json";
        exec = "${ds-battery}/bin/ds-battery.sh";
        escape = "true";
      };
      "custom/blank" = { format = " "; };
    }];
    style = ''
      @define-color foreground #${colors.base06};
      @define-color background #${colors.base00};
      @define-color box-bg #${colors.base01};
      @define-color workspace-bg #${colors.base00};

      label:disabled,
      button:disabled {
          color: inherit;
          background-image: none;
      }

      * {
        font-family: JetBrainsMono Nerd Font;
        font-size: 9pt;
      }

      window#waybar {
        background: @background;
        color: @foreground;
      }

      #pulseaudio, #mpd, #custom-waybar-mpris, #custom-ds-battery, #window, #keyboard-state, #tray, #clock {
       background: @box-bg;
       padding: 0 10px 0 10px;
       margin: 5px 10px 5px 0;
       border-radius: 10px;
      }

      #tray, #clock {
       margin: 5px 0 5px 0;
      }

      window#waybar.empty #window {
        background: @background;
      }

      #workspaces {
        margin: 5px 0 5px 0;
        padding-left: 10px;
      }

      #workspaces button {
        color: @foreground;
        background: @box-bg;
        padding: 0 5px;
      }

      #workspaces button:last-child {
        background: @box-bg;
        border-radius: 0px 10px 10px 0;
      }

      #workspaces button:first-child {
        background: @box-bg;
        border-radius: 10px 0px 0px 10px;
      }

      #workspaces button:only-child {
        background: @box-bg;
        border-radius: 10px 10px 10px 10px;
      }

      #workspaces button.active {
        color: @foreground;
        background: @box-bg;
        font-weight: bold;
      }

      #workspaces button.unfocused {
        color: @foreground;
        background: @box-bg;
        /* background: @box-bg; */
      }
    '';
  };
}

