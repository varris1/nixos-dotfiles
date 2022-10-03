{ config, pkgs, ... }:
let
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
in {
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 32;

      modules-left = [ "custom/blank" "sway/workspaces" "sway/mode" ];
      modules-center = [ "sway/window" ];
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

      "clock" = { format = "{:%a %d. %B  %H:%M}"; };

      "pulseaudio" = {
        scroll-step = 5;
        format = "{icon} {volume}%";
        format-icons = [ "" "" "墳" "" ];
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
      @define-color foreground #EBDBB2;
      @define-color background #282828;
      @define-color box-bg #3C3836;

      * {
        font-family: JetBrainsMono Nerd Font;
        font-size: 9pt;
      }

      window#waybar {
        background: @background;
        color: @foreground;
        border-bottom: 1px solid @box-bg;
      }

      #pulseaudio, #mpd, #custom-waybar-mpris, #custom-ds-battery, #window, #keyboard-state {
       background: @box-bg;
       padding: 0 10px 0 10px;
       margin: 5px 10px 5px 0;
      }

      window#waybar.empty #window {
        background: @background;
      }

      #tray, #clock {
       background: @box-bg;
       padding: 0 10px 0 10px;
       margin: 5px 0 5px 0;
      }

      #clock {
        margin: 5px 0 5px 0;
      }

      #workspaces {
        background: @box-bg;
        color: @foreground;
        margin: 5px 0 5px 0;
      }

      #workspaces button {
        border-radius: 0;
        color: @foreground;
        background: @background;
        padding: 0 5px;
      }

      #workspaces button.focused {
        border-radius: 0;
        color: @foreground;
        background: @box-bg;
        font-weight: bold;
      }

      #workspaces button.unfocused {
        border-radius: 0;
        color: @foreground;
        background: @background;
      }
    '';
  };
}
