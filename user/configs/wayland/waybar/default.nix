{ pkgs, lib, ... }:
let
  wobsock = "/tmp/wob-vol.fifo";

  ds-battery = pkgs.writeShellScriptBin "ds-battery.sh" ''
    ds_capacity_file="/sys/class/power_supply/ps-controller-battery-e8:47:3a:46:72:1b/capacity"
    ds_status_file="/sys/class/power_supply/ps-controller-battery-e8:47:3a:46:72:1b/status"

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
    	sleep 10
    done
  '';
in
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    settings = [{
      layer = "top";
      position = "top";
      height = 32;

      modules-left = [ "wlr/workspaces" "custom/blank" "hyprland/window" ];
      modules-center = [ "wireplumber" "custom/blank" "mpd" ];
      modules-right = [
        "custom/ds-battery"
        "tray"
        "clock"
        "custom/blank"
      ];

      "wlr/workspaces" = {
        on-click = "activate";
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
        persistent_workspaces = {
          "1" = [ "DP-1" ];
          "2" = [ "DP-1" ];
          "3" = [ "DP-1" ];
          "4" = [ "HDMI-A-1" ];
          "5" = [ "HDMI-A-1" ];
          "6" = [ "HDMI-A-1" ];
        };
      };

      "hyprland/window" = {
        separate-outputs = true;
      };

      "clock" = {
        format = "{:%a %d. %B  %H:%M}";
      };

      "wireplumber" = {
        scroll-step = 5;
        format = "{icon} {volume}%";
        format-icons = [ "" "" "󰕾" "" ];
        ignored-sinks = [ "Easy Effects Sink" ];
        on-scroll-up = "${pkgs.pamixer}/bin/pamixer -i 10 --get-volume > ${wobsock}";
        on-scroll-down = "${pkgs.pamixer}/bin/pamixer -d 10 --get-volume > ${wobsock}";
      };

      "tray" = {
        icon-size = 16;
        spacing = 10;
      };

      "mpd" = {
        format =
          "{stateIcon} {artist} - {title}  {elapsedTime:%M:%S}/{totalTime:%M:%S}";
        format-stopped = "󰓛 stopped";
        state-icons = {
          playing = "";
          paused = "󰏤";
        };
        on-click = "${pkgs.foot}/bin/foot -e ${pkgs.ncmpcpp}/bin/ncmpcpp";
      };

      "custom/ds-battery" = {
        return-type = "json";
        exec = "${ds-battery}/bin/ds-battery.sh";
        escape = "true";
      };

      "custom/blank" = { format = " "; };

    }];

    style = builtins.readFile ./style.css;
  };
}

